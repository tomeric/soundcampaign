step 'I have a user account' do
  @current_user  = create :user
  @current_email = @current_user.email
end

step 'I am signed in' do
  send 'I have a user account' unless @current_user
  send 'I sign in with my credentials'
end

step 'I sign in with my credentials' do
  visit new_user_session_url
  
  fill_in 'Email',
    with: @current_email
  fill_in 'Password',
    with: 'password'
  
  click_button 'Sign in'
end

step 'I follow the instructions to reset my password' do
  visit new_user_session_url
  
  click_link 'Forgot your password?'
  
  fill_in 'Email',
    with: @current_email
  click_button 'Send me reset password instructions'
  
  open_email @current_email
  click_email_link_matching %r{password/edit}
  
  fill_in 'New password',
    with: 'password'
  fill_in 'Confirm new password',
    with: 'password'
  click_button 'Change my password'
end
