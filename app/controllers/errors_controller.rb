class ErrorsController < ApplicationController
  def not_found
    @page_header = "Not found"
    render status: 404
  end

  def unacceptable
    @page_header = "Unacceptable"
    render status: 422
  end

  def internal_error
    @page_header = "Internal error"
    render status: 500
  end
end
