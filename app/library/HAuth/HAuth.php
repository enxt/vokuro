<?php

namespace Vokuro\HAuth;

use Phalcon\Mvc\User\Component,
	Vokuro\Models\Users,
	Vokuro\Models\RememberTokens,
	Vokuro\Models\SuccessLogins,
	Vokuro\Models\FailedLogins,
    Hybrid_Auth as HybridAuth;


/**
 * Vokuro\HAuth\HAuth
 *
 * Manages Hybrid Authentication/Identity Management in Vokuro
 */
class HAuth extends Component
{
    
    /**
     * 
     * @var Hybrid_Auth
     */
    public $hybridAuth;
 
    /**
     * 
     * @var Hybrid_Provider_Adapter
     */
    public $adapter;
 
    /**
     * 
     * @var Hybrid_User_Profile
     */
    public $userProfile;
 
    
    /**
     * 
     * @var Hybrid_allowed_providers
     */
    public $allowedProviders = array('google',);

    
    function __construct()  {
        require_once __DIR__ . '/../../../vendor/HybridAuth/hybridauth/Hybrid/Auth.php'; 
        $this->hybridAuth = new HybridAuth((array)$this->config->hybridauth);
    }
    
    /**
     * Check if exists the user in the database
	 *
     * @param string $provider
	 * @param array $user_profile
     * @return boolean
	 */
    public function exists($provider, $user_profile) {
        $user = Users::findFirst('provider=\'' . $provider . '\' and identifier=\'' . $user_profile->identifier . '\'');
        if($user == null) return false;
        
        return true;
    }

	/**
	 * Checks the user credentials
	 *
	 * @param string $provider_name
     * @param array $user_profile
	 * @return boolan
	 */
	public function checkIn($provider_name, $user_profile)
	{
		//Check if the user exist
        $user = Users::findFirst('provider=\'' . $provider_name . '\' and identifier=\'' .  $user_profile->identifier . '\'');
		
        if ($user == false)
			throw new Exception('Wrong email/password combination');
        else {
            //Check if the user was flagged
    	    $this->checkUserFlags($user);
        }

		//Register the successful login
		$this->saveSuccessLogin($user);

		$this->session->set('auth-identity', array(
			'id' => $user->id,
			'name' => $user->name,
			'profile' => $user->profile->name
		));
        
        return $this->response->redirect('users');
	}

	/**
	 * Creates the remember me environment settings the related cookies and generating tokens
	 *
	 * @param Vokuro\Models\Users $user
	 */
	public function saveSuccessLogin($user)
	{
		$successLogin = new SuccessLogins();
		$successLogin->usersId = $user->id;
		$successLogin->ipAddress = $this->request->getClientAddress();
		$successLogin->userAgent = $this->request->getUserAgent();
		if (!$successLogin->save()) {
			$messages = $successLogin->getMessages();
			throw new Exception($messages[0]);
		}
	}

	/**
	 * Creates the remember me environment settings the related cookies and generating tokens
	 *
	 * @param Vokuro\Models\Users $user
	 */
	public function createRememberEnviroment(Users $user)
	{

		$userAgent = $this->request->getUserAgent();
		$token = md5($user->email . $user->password . $userAgent);

		$remember = new RememberTokens();
		$remember->usersId = $user->id;
		$remember->token = $token;
		$remember->userAgent = $userAgent;

		if ($remember->save() != false) {
			$expire = time() + 86400 * 8;
			$this->cookies->set('RMU', $user->id, $expire);
			$this->cookies->set('RMT', $token, $expire);
		}

	}

	/**
	 * Check if the session has a remember me cookie
	 *
	 * @return boolean
	 */
	public function hasRememberMe()
	{
		return $this->cookies->has('RMU');
	}

	/**
	 * Logs on using the information in the coookies
	 *
	 * @return Phalcon\Http\Response
	 */
	public function loginWithRememberMe()
	{
		$userId = $this->cookies->get('RMU')->getValue();
		$cookieToken = $this->cookies->get('RMT')->getValue();

		$user = Users::findFirstById($userId);
		if ($user) {

			$userAgent = $this->request->getUserAgent();
			$token = md5($user->email . $user->password . $userAgent);

			if ($cookieToken == $token) {

				$remember = RememberTokens::findFirst(array(
					'usersId = ?0 AND token = ?1',
					'bind' => array($user->id, $token)
				));
				if ($remember) {

					//Check if the cookie has not expired
					if ((time() - (86400 * 8)) < $remember->createdAt) {

						//Check if the user was flagged
						$this->checkUserFlags($user);

						//Register identity
						$this->session->set('auth-identity', array(
							'id' => $user->id,
							'name' => $user->name,
							'profile' => $user->profile->name
						));

						//Register the successful login
						$this->saveSuccessLogin($user);

						return $this->response->redirect('users');
					}
				}

			}

		}

		$this->cookies->get('RMU')->delete();
		$this->cookies->get('RMT')->delete();

		return $this->response->redirect('session/login');
	}

	/**
	 * Checks if the user is banned/inactive/suspended
	 *
	 * @param Vokuro\Models\Users $user
	 */
	public function checkUserFlags(Users $user)
	{
		if ($user->active <> 'Y')  {
			throw new Exception('The user is inactive');
		}

		if ($user->banned <> 'N')  {
			throw new Exception('The user is banned');
		}

		if ($user->suspended <> 'N')  {
			throw new Exception('The user is suspended');
		}
	}

	/**
	 * Returns the current identity
	 *
	 * @return array
	 */
	public function getIdentity()
	{
		return $this->session->get('auth-identity');
	}

	/**
	 * Returns the current identity
	 *
	 * @return string
	 */
	public function getName()
	{
		$identity = $this->session->get('auth-identity');
		return $identity['name'];
	}

	/**
	 * Removes the user identity information from session
	 */
	public function remove()
	{
		if ($this->cookies->has('RMU')) {
			$this->cookies->get('RMU')->delete();
		}
		if ($this->cookies->has('RMT')) {
			$this->cookies->get('RMT')->delete();
		}

		$this->session->remove('auth-identity');
	}

	/**
	 * Auths the user by his/her id
	 *
	 * @param int $id
	 */
	public function authUserById($id)
	{
		$user = Users::findFirstById($id);
		if ($user == false) {
			throw new Exception('The user does not exist');
		}

		$this->checkUserFlags($user);

		$this->session->set('auth-identity', array(
			'id' => $user->id,
			'name' => $user->name,
			'profile' => $user->profile->name
		));

	}

	/**
	 * Get the entity related to user in the active identity
	 *
	 * @return \Vokuro\Models\Users
	 */
	public function getUser()
	{
		$identity = $this->session->get('auth-identity');
		if (isset($identity['id'])) {

			$user = Users::findFirstById($identity['id']);
			if ($user == false) {
				throw new Exception('The user does not exist');
			}

			return $user;
		}

		return false;
	}
    
    /**
     *
     * @param string $provider
     * @return bool 
     */
    public function validateProviderName($provider)
    {
        if (!is_string($provider))
            return false;
        if (!in_array($provider, $this->allowedProviders))
            return false;
 
        return true;
    }

}