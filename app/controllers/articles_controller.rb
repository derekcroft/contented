class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find params[:id]
    @comments = @article.comments
    @comment = Comment.new :article_id => @article.id
  end

  def edit
    @article = Article.find params[:id]
  end

  def create
    @article = Article.create params[:article]
    if @article.valid?
      flash[:notice] = "#{@article.title} was successfully created"
      redirect_to articles_path
    else
      flash[:warning] = "Article creation failed"
      render :action => "new"
    end
  end

  def update
    @article = Article.find params[:id]
    @article.update_attributes params[:article]

    if @article.valid?
      redirect_to(article_path(@article))
    else
      render :action => "new"
    end
  end

  def new
    @article = Article.new
  end

  def destroy
    Article.delete params[:id]
    flash[:notice] = "Article was successfully destroyed"
    redirect_to articles_path
  end
end
