<?php

namespace Vokuro\Mail;

use Phalcon\Mvc\User\Component,
	Vokuro\Models\Users,
	Phalcon\Mvc\View,
	PHPMailer;

require_once __DIR__ . '/../../../vendor/PHPMailer/class.phpmailer.php';
require_once __DIR__ . '/../../../vendor/AWSSDKforPHP/sdk.class.php';

/**
 * Vokuro\Mail\Mail
 *
 * Sends e-mails based on pre-defined templates
 */
class Mail extends Component
{

	protected $_transport;

	protected $_amazonSes;

	protected $_directSmtp = false;

	/**
	 * Send a raw e-mail via AmazonSES
	 *
	 * @param string $raw
	 */
	private function _amazonSESSend($raw)
	{

		if ($this->_amazonSes == null) {
			$this->_amazonSes = new \AmazonSES($this->config->amazon->AWSAccessKeyId, $this->config->amazon->AWSSecretKey);
			$this->_amazonSes->disable_ssl_verification();
		}

		$response = $this->_amazonSes->send_raw_email(array(
			'Data' => base64_encode($raw)
		), array(
			'curlopts' => array(
				CURLOPT_SSL_VERIFYHOST => 0,
				CURLOPT_SSL_VERIFYPEER => 0
			)
		));

		if (!$response->isOK()) {
			throw new Exception('Error sending email from AWS SES: ' . $response->body->asXML());
		}

		return true;
	}

	/**
	 * Applies a template to be used in the e-mail
	 *
	 * @param string $name
	 * @param array $params
	 */
	public function getTemplate($name, $params)
	{

		$parameters = array_merge(array(
			'publicUrl' => $this->config->application->publicUrl,
		), $params);

		return $this->view->getRender('emailTemplates', $name, $parameters, function($view){
			$view->setRenderLevel(View::LEVEL_LAYOUT);
		});

		return $view->getContent();
	}

	/**
     * Sends e-mails via AmazonSES based on predefined templates
	 *
	 * @param array $to
	 * @param string $subject
	 * @param string $name
	 * @param array $params
	 */
	public function send($to, $subject, $name, $params)
	{

		//Settings
		$mailSettings = $this->config->mail;

		$template = $this->getTemplate($name, $params);

		//Create a new PHPMailer instance
        $mail = new PHPMailer();
        //$mail->SMTPDebug  = 2;
        //Set the subject line
        $mail->Subject = $subject;
        //Set who the message is to be sent to
        foreach($to as $email=>$name) {
            $mail->AddAddress($email, $name);
    	}
        //Set who the message is to be sent from
        $mail->SetFrom($mailSettings->fromEmail, $mailSettings->fromName);
        //Read an HTML message body from an external file, convert referenced images to embedded, convert HTML into a basic plain-text alternative body
        $mail->MsgHTML($template, dirname(__FILE__));

  		if ($this->_directSmtp || ($this->config->amazon->AWSAccessKeyId == '' && isset($mailSettings->smtp))) {
  			$mail->IsSMTP();
            //Set the hostname of the mail server
            $mail->Host = (isset($mailSettings->smtp->security)?$mailSettings->smtp->security.'://':'') . $mailSettings->smtp->server;
            //Set the SMTP port number - likely to be 25, 465 or 587
            $mail->Port = $mailSettings->smtp->port;
            //Whether to use SMTP authentication
            $mail->SMTPAuth = isset($mailSettings->smtp->security)?true:false;
            
            //Username to use for SMTP authentication
            $mail->Username   = $mailSettings->smtp->username;
            //Password to use for SMTP authentication
            $mail->Password   = $mailSettings->smtp->password;

			return $mail->Send();

		} else {
			return $this->_amazonSESSend($mail->GetSentMIMEMessage());
		}

	}

}