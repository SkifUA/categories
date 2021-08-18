class ApplicationInteractor
  include Interactor

  # Set default callbacks
  # IMPORTANT Needed to correctly inheriting before/after/around callbacks
  def self.inherited(klass)
    klass.class_eval do
      before :validation
      around :interactor_logging
    end
  end

  # Run Interactor in background job
  def self.call_later(context = {}, opt = {})
    ApplicationInteractor::Job.set(opt).perform_later(handler: self.name, context: context)
  end

  # Wrapper to Interactor.call
  # Set general logs: Start/Finish etc
  def interactor_logging(interactor)
    Rails.logger.info "#{self.class} START"
    start_time = Time.now
    interactor.call

  rescue ApplicationInteractor::SuccessError => _
    Rails.logger.info "#{self.class} Hard success, Interactor will stop but with success response"

  rescue Interactor::Failure => exp
    raise exp

  rescue ActiveRecord::RecordNotFound => exp
    add_error!(:record_not_found, t: { record: exp.model }, exp: exp)

  rescue ActiveRecord::RecordInvalid => exp
    add_error!(:record_invalid, exp.message, exp: exp)

  rescue Exception => exp
    add_error!(:exception, exp: exp)

  ensure
    exec_time = ((Time.now.to_f - start_time.to_f) * 1000).to_i
    if context.success?
      Rails.logger.info("#{self.class} FINISH. TIME: #{exec_time}ms, SUCCESS: true")
    else
      Rails.logger.error("#{self.class} FINISH. TIME: #{exec_time}ms, SUCCESS: false, ERRORS: #{context.errors}")
    end
  end

  # Default validator to Current Interactor
  def validation
    #
  end

  def fail(attr = {})
    Rails.logger.info "#{self.class}.#{__method__} Soft fail, Interactor will continue its execution"
    context.fail!(attr) rescue nil
  end

  def fail!(attr = {})
    context.fail!(attr)
  end

  def success!(attr = {})
    attr.each { |key, value| context[key.to_sym] = value }
    raise ApplicationInteractor::SuccessError, ''
  end

  def add_error(code, message = nil, t: {}, extensions: {}, exp: nil)
    Rails.logger.error "#{self.class} Error: #{code} #{message}"
    if exp.present?
      Rails.logger.error "#{self.class} Exp: #{exp.message}"
      Rails.logger.error exp.backtrace_local.join($/)
    end

    context.errors ||= []
    context.errors << { message: message,  exp: exp }
    context.fail! rescue nil
  end

  def add_error!(code, message = nil, t: {}, extensions: {}, exp: nil)
    add_error(code, message, t: t, extensions: extensions, exp: exp)
    context.fail!
  end

  # General ApplicationInteractor errors
  class Error < StandardError
  end

  # General Error in calling
  class SuccessError < Error
  end

  # General Interactor Job to run code in background (async)
  class Job < ApplicationJob

    def perform(handler: nil, context: {})
      if (handler = handler&.constantize) <= ApplicationInteractor
        handler.call!(context)
      else
        Rails.logger.error "#{self.class.name}.#{__method__} Invalid handler: #{handler}"
      end
    end
  end
end
