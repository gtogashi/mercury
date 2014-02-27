class PagesController < ApplicationController

  def update_contents
    page = Page.find(params[:id])
    page.contents = Hash.new if page.contents.nil?
    params[:content].each_pair do |k, v|
      page.contents[k.to_sym] = v[:value]
    end
    page.save!
    render :json => {:message => "OK"}
  end

end
