Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['APP_ID'], ENV['APP_SECRET'],
  scope: 'email,public_profile',
  info_fields: 'id,cover,name,first_name,last_name,age_range,link,gender,locale,picture,timezone,updated_time,verified,email',
  image_size: { width: 480, height: 480 }
  provider :developer
end


