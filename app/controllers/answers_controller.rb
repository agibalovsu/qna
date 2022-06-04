# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :find_question, only: :create

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@answer.question)
    else
      render :new
    end
  end

  private

  def find_question
    @question = if params[:question_id]
                  Question.find(params[:question_id])
                else
                  @answer.question
                end
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
