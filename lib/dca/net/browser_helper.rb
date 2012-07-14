module DCA
  module Net
    module BrowserHelper
      #def included(base)
      #  base.extend ClassMethods
      #end

      #module ClassMethods
      #end

      def browser(name = :ff, profile = 'default')
        @browser ||= Watir::Browser.new name, :profile => profile
      end

      def browser_close
        @browser.close if @browser
      end
    end
  end
end