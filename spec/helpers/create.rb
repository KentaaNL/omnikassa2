def create(factory, params = {})
  # could use reflection here
  case factory
  when :refresh_response
    RefreshResponseFactory.create params
  end
end
