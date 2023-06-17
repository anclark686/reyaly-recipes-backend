Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins 'localhost:5173', 'reyaly-recipes-6afe74ae7b4d.herokuapp.com', 'reyaly-recipes-frontend.vercel.app', 'reyaly-recipes.netlify.app'
      resource '*',
        headers: :any,
        methods: %i(get post put patch delete options head)
    end
  end