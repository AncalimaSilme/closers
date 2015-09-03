# coding: utf-8

class ClosureRulesController < ApplicationController
  layout 'admin'

  def index
    @closure_rules = ClosureRule.all
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
end