<?php

namespace Vokuro\Controllers;

class IndexController extends ControllerBase
{

    public function indexAction()
    {
        //Get the current identity
		$identity = $this->auth->getIdentity();
        if(is_array($identity) && in_array($identity['profile'], array('Administrators', 'Users')))
    	    $this->view->setTemplateBefore('private');
        else
            $this->view->setTemplateBefore('public');
    }

}

