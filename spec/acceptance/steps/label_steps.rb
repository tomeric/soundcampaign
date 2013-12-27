step 'I have a label' do
  @current_label = create :label, organization: @current_user.organization
end

step 'I add a new label' do
  visit labels_url
  
  within '.section-header-options' do
    click_link 'Label'
  end
  
  expect {
    fill_in 'Label name',
      with: FactoryGirl.generate(:brand)
    
    click_button 'Save'
  }.to change {
    Label.count
  }.by +1
  
  @current_label = Label.last
end

step 'I update my label' do
  dom_id = "#label_#{@current_label.id}"
  
  visit labels_url
  within dom_id do
    click_link 'Edit'
  end
  
  @old_label_name = @current_label.name.dup
  @new_label_name = FactoryGirl.generate(:brand)
  
  fill_in 'Label name',
    with: @new_label_name
  click_button 'Save'
end

step 'I delete my label' do
  dom_id = "#label_#{@current_label.id}"
  
  visit labels_url
  within dom_id do
    click_link 'Edit'
  end
  
  expect {
    click_link 'Delete'
  }.to change {
    Label.count
  }.by -1
end

step 'I see the label overview' do
  expect(page).to have_css '.section#labels'
  within '.section-header-title' do
    if @current_user.organization.labels.present?
      expect(page).to have_content 'Your Labels'
    else
      expect(page).to have_content "Welcome #{@current_user.name}"
    end
  end
end

step 'I see my label' do
  dom_id = "#label_#{@current_label.id}"
  
  expect(page).to have_css dom_id
  within dom_id do
    expect(page).to have_content @current_label.name
  end
end

step 'I see my updated label' do
  dom_id = "#label_#{@current_label.id}"
  
  expect(page).to have_css dom_id
  within dom_id do
    expect(page).to have_content @new_label_name
  end
end

step "I don't see my label" do
  dom_id = "#label_#{@current_label.id}"
  
  expect(page).to_not have_css dom_id
end
