# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Liked

  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[show destroy update]
  before_action :current_user_to_gon, only: %i[index show]
  before_action :init_comment, only: %i[show update]
  before_action :set_subscription, only: %i[show update]

  authorize_resource

  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.badge ||= Badge.new
  end

  def edit; end

  def create
    @question = current_user.questions.with_attached_files.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your Question was successfully created'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    if current_user.present?
      @question.destroy
      redirect_to questions_path, notice: 'Question was successfully deleted'
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url],
                                                    badge_attributes: %i[title image])
  end

  def current_user_to_gon
    gon.current_user = current_user
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      @question.to_json(include: :user)
    )
  end

  def init_comment
    @comment = Comment.new
  end

  def set_subscription
    @subscription ||= current_user&.subscriptions&.find_by(question: question)
  end
end
