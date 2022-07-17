# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy update best]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    flash[:notice] = 'Your answers successfully created.' if @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
    flash[:notice] = 'Answer successfully deleted.'
  end

  def best
    @answer.best! if current_user.author?(@answer.question)
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = if params[:question_id]
                  Question.find(params[:question_id])
                else
                  @answer.question
                end
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
