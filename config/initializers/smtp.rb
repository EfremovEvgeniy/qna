ActionMailer::Base.smtp_settings = {
  domain: 'http://64.225.65.170',
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      'qna',
  password:       Rails.application.credentials[Rails.env.to_sym][:sendgrid][:api_key]
}
