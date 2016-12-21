class User < ApplicationRecord

  def process(auth)
    self.email = auth.info.email
    self.name = auth.info.name
    self.image = auth.info.image
    self.verified = auth.info.verified
    self.facebook_id = auth.extra.raw_info.id
    self.first_name = auth.extra.raw_info.first_name
    self.last_name = auth.extra.raw_info.last_name
    self.link = auth.extra.raw_info.link
    self.gender = auth.extra.raw_info.gender
    self.picture = auth.extra.raw_info.picture.data.url
    self.timezone = auth.extra.raw_info.timezone
    self.updated_time = auth.extra.raw_info.updated_time
    self.locale = auth.extra.raw_info.locale
    #need to test other age ranges
    self.age_range = auth.extra.raw_info.age_range.min.join
  end
end
