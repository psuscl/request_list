class RequestListMailer < ApplicationMailer
  def email(user_email, mapper)
    # the plugin dir is not in the view path in this context, so render the template manually
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    email_body = view.render(file: File.join(File.dirname(__FILE__), '..', 'views', 'request_list_mailer', 'email'),
                             locals: {mapper: mapper},
                             layout: 'layouts/mailer')

    mail(
         from: I18n.t('plugin.request_list.email.from'),
         to: user_email,
         subject: I18n.t('plugin.request_list.email.subject'),
         content_type: 'text/html',
         body: email_body,
         )
  end
end
