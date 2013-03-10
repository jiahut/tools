@echo off
rem if env['path'].include? dict.rb 
rem 	ruby -S dict.rb %*
rem else
ruby %~dp1/dict.rb %*
rem end