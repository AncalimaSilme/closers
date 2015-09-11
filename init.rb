# coding: utf-8

Redmine::Plugin.register :closers do
  name 'Closers plugin'
  author 'Alexander Kazachkin'
  description 'This is a plugin for Redmine. It is help you close old issues'
  version '0.0.2'
  url 'https://github.com/AncalimaSilme/closers'


  menu :admin_menu, :closure_rules, { :controller => 'closure_rules', :action => 'index' }, :caption => :closure_rules_page_title

  settings  :partial => 'settings/closers_settings', :default => {'empty' => true}
end
