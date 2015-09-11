# coding: utf-8

require 'rake'
RedmineApp::Application.load_tasks

class ClosureRulesController < ApplicationController
  layout 'admin'

  def index
    @closure_rule = ClosureRule.new
    @closure_rules = ClosureRule.order("active DESC, id ASC")
  end

  def create
    @closure_rule = ClosureRule.new(params[:closure_rule])
    if @closure_rule.save()
      flash[:notice] = l(:notice_successful_create)
    else
      flash[:error] = l("errors.failure_create_closure_rule")
    end

    redirect_to closure_rules_path
  end

  def destroy
    @closure_rule = ClosureRule.find(params[:id])
    if @closure_rule.destroy()
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l("errors.failure_delete_closure_rule")
    end

    redirect_to closure_rules_path
  end


  # CUSTOM ACTION

  def activate
    @closure_rule = ClosureRule.find(params[:closure_rule_id])
    @closure_rule.update_attribute :active, !@closure_rule.active
    redirect_to closure_rules_path
  end

  def apply
    if params[:closure_rule_id]
      if Rake::Task["redmine:plugin:closers:run"].invoke(params[:closure_rule_id])
        flash[:notice] = l("success.apply_closure_rule")
      else
        flash[:error] = l("errors.failure_apply_closure_rule")
      end
    end
    
    Rake::Task["redmine:plugin:closers:run"].reenable
    redirect_to closure_rules_path
  end
end