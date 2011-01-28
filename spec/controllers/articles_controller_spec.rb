require 'spec_helper'

describe ArticlesController do
  before(:each) do
    @attributes = {"title" => "excellent", "body" => "nonsense"}
  end
  
  describe "GET 'index'" do
    it "should return available articles" do
      article = mock(Article, @attributes)
      articles = Article.expects(:all).returns [article]
      get 'index'
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @article = mock Article
      @article.stub!(:id).returns 2
    end

    it "should destroy an article" do
      Article.expects(:delete).with(@article.id).returns @article
      delete 'destroy', :id => @article.id
    end
    
    it "should redirect to the articles index" do
      delete 'destroy', :id => @article.id
      response.code.should == "302"
      response.should redirect_to(articles_path)
    end
  end
  
  describe "GET 'show'" do
    it "should return the relevant article" do
      article = mock Article
      article.stub!(:id).returns 2
      Article.expects(:find).with(article.id).returns article
      get 'show', :id => article.id
    end
  end

  describe "GET 'new'" do
    it "should build a new article" do
      article = mock(Article, :save => false)
      Article.expects(:new).returns article
      get 'new'
    end
  end
  
  describe "GET 'edit'" do
    it "should get the article" do
      article = mock Article
      article.stub!(:id).returns 2
      Article.expects(:find).with(2).returns article
      get 'edit', :id => article.id
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @article = mock Article
      @article.stub!(:id).returns 2
      @attrs = { "body" => "bar", "title" => "foo" }
      Article.expects(:find).with(2).returns @article
      @article.expects(:update_attributes).with(@attrs).returns true
    end

    context "success" do
      it "should redirect to show article page" do
        @article.stub!(:valid?).returns true
        put 'update', :id => 2, :article => @attrs      
        response.should redirect_to(article_path(@article))
      end
    end

    context "failure" do
      it "should render the new article template" do
        @article.stub!(:valid?).returns false
        put 'update', :id => 2, :article => @attrs      
        response.should render_template("new")
      end
    end
  end
  
  describe "POST 'create'" do
    context "success" do
      before(:each) do
        @article = mock(Article, @attributes)
      end
      
      it "should create a new article" do
        Article.expects(:create).with(@attributes).returns @article
        post :create, :article => @attributes
      end
      
      it "should redirect to the articles path" do
        post :create, :article => @attributes
        response.code.should == "302"
        response.should redirect_to(articles_path)
      end
    end

    context "failure" do
      before(:each) do
        @article = mock(Article, :title => "")
      end

      it "should create a new article" do
        Article.expects(:create).with({}).returns @article
        post :create, :article => {}
      end

      it "should not redirect" do
        post :create, :article => {}
        response.should_not redirect_to(articles_path)
        response.code.should == "200"
      end
    end
  end
end
