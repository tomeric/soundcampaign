step 'I have a user account' do
  @current_user  = create :user
  @current_email = @current_user.email
end

step 'I have been invited' do
  @current_subscriber = create :subscriber
  @current_email      = @current_subscriber.email
end

step 'I open my invite' do
  visit new_user_registration_url(invite_code: @current_subscriber.try(:invite_code))
end

step 'I sign up' do
  expect {
    fill_in 'Name',
      with: generate(:name)
    
    fill_in 'Email',
      with: @current_email
    
    within '#user_password_input' do
      fill_in 'Password',
        with: 'password'
    end
    
    within '#user_password_confirmation_input' do
      fill_in 'Password confirmation',
        with: 'password'
    end
    
    click_button 'Sign up'
  }.to change {
    User.count
  }.by +1
  
  @current_user = User.where(email: @current_email).last
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

step 'I see my dashboard' do
  expect(page).to have_css '.account-nav.logged-in'
  expect(page).to have_css '.backend-layout'
end
