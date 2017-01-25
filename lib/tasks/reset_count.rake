desc "recount user and story favorites and hides"
task reset_count: [:environment] do
  Story.reset_favorites_count
  Story.reset_blocks_count
  User.reset_favorites_count
  User.reset_blocks_count
end
