class SearchController < ApplicationController
  def index
    if params[:query]
      search_query = params[:query].split()
      if search_query.length == 1
        # single keyword
        @results = ::JsonDataService.new.call.find_all{|e| /#{params[:query].titleize}/ =~ e[:Type] ||  /#{params[:query].titleize}/ =~e[:"Designed by"] || /#{params[:query].titleize}/ =~e[:Name]}
      elsif search_query.length > 1
        # double keyword
        if params[:query].include?('-')
          multi_search = params[:query].split(' -'); query1, query2 = multi_search.first.titleize, multi_search.last.titleize
          @results = ::JsonDataService.new.call.find_all{|e| /#{query2}/ != e[:Type] &&  /#{query1}/ =~e[:"Designed by"]} - ::JsonDataService.new.call.find_all{|e| /#{query2}/ =~ e[:Type] &&  /#{query1}/ =~e[:"Designed by"]}
        else
          query1, query2 = search_query.first.titleize, search_query.last.titleize if search_query.length == 2
          multi_search = params[:query].split(' ', 2); query1, query2 = multi_search.first.titleize, multi_search.last.titleize if search_query.length == 3
          @results = ::JsonDataService.new.call.find_all{|e| /#{query1}/ =~ e[:Type] &&  /#{query2}/ =~e[:"Designed by"]}
        end
      end
      # render json: @results, status: 200
    end
  end
end
