RSpec::Matchers.define :have_access_to do |method, action, params = {}|
  match do
    # We don't want to actually execute the action,
    # just test that we can or cannot call it:
    controller.stub(action)
              .and_return(true)
    
    # We have to deal with implicit rendering:
    controller.stub(:render)
              .and_return(true)
    
    send(method, action, params)
    
    redirect_url = response.headers['Location']
    login_url    = controller.new_user_session_url
    
    redirect_url.nil? || redirect_url.exclude?(login_url)
  end
  
  failure_message_for_should do
    "expected that we would have access to #{method} :#{action}#{params ? " with params: #{params.inspect}" : nil}"
  end
  
  failure_message_for_should_not do
    "expected that we would not have access to #{method} :#{action}#{params ? " with params: #{params.inspect}" : nil}"
  end
  
  description do
    "have access to #{method} :#{action}"
  end
end
