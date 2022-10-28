# frozen_string_literal: true

require 'roda'
require 'slim'

module Transfer
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'CafeNomad' do
        routing.is do
          # POST /project/
          routing.post do
            wordterm = routing.params
            region = routing.params[0]#.downcase
            city_arr = ['新竹', '台北', '宜蘭', '臺北', '新北', '桃園', '苗栗', '台中']
            region.halt 400 unless (city_arr.any?(region) )  &&
                                    (region.split('').count >= 2)
            owner, project = gh_url.split('/')[-2..]

            routing.redirect "CafeNomad/#{owner}/#{project}"
          end
        end

        routing.on String, String do |owner, project|
          # GET /project/owner/project
          routing.get do
            github_project = Github::ProjectMapper
              .new(GH_TOKEN)
              .find(owner, project)

            view 'project', locals: { project: github_project }
          end
        end
      end
    end
  end
end
