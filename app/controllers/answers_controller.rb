# frozen_string_literal: true

class AnswersController < ApplicationController
  include Liked

  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy update best]
  before_action :init_comment, only: %i[create]

  authorize_resource

  after_action :publish_answer, only: :create

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    flash[:notice] = 'Your answers successfully created.' if @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Answer successfully deleted.'
  end

  def best
    @answer.best!
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = if params[:question_id]
                  Question.with_attached_files.find(params[:question_id])
                else
                  @answer.question
                end
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    files = @answer.files.map { |f| { id: f.id, name: f.filename.to_s, url: url_for(f) } }

    ActionCable.server.broadcast(
      "question_#{@answer.question_id}_answers", {
        answer: @answer,
        files: files,
        links: @answer.links,
        rating: @answer.rating_sum
      }.to_json
    )
  end

  def init_comment
    @comment = Comment.new
  end
end
