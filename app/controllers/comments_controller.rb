class CommentsController < ApplicationController
  def create
    @article = Article.find params[:article_id]
    @comments = article.comments
    @comment = @article.comments.create params[:comment]

    if @comment.valid?
      redirect_to @article
    else
      render "articles/show"
    end
  end
end
