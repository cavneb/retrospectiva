require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin/users/search.js.rjs" do
  
  before(:each) do
    mock_current_user! :admin? => true
    @user = mock_model(User,
      :email => 'me@home.com', :username => 'me', :name => 'Full Name', 
      :active? => true , :admin? => false, :groups => [], :public? => false, 
      :current? => false, :last_admin? => false, :time_zone => 'London')
    user_2 = mock_model(User)

    assigns[:users] = [@user, user_2].paginate(:per_page => 1)
  end

  def do_render
    render "/admin/users/search.js.rjs", :helpers => ['admin_area', 'application']
  end
  
  it "should update the users" do
    do_render
    response.should have_rjs(:replace_html, 'users', :partial => 'user', :collection => @users)
  end

  it "should hide pagination if a search term is given" do
    template.params[:term] = 'word'
    do_render
    response.body.should match(/el\.hide\(\)/)
  end            

  it "should show pagination if a search term is blank" do
    template.params[:term] = ''
    do_render
    response.body.should match(/el\.show\(\)/)
  end            

end

