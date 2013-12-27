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

step 'I have been invited' do
  @current_subscriber = create :subscriber
  @current_email      = @current_subscriber.email
end

step 'I open my invite' do
  visit new_user_registration_url(invite_code: @current_subscriber.try(:invite_code))
end
