class BallotPaperMailer < ApplicationMailer
  default from: 'vk@svobodni.cz'

  def ballot_paper_mail(election, ballot_paper, user)
    @election = election
    @ballot_paper = ballot_paper
    user_email = user['info']['person']['email']

    mail(to: user_email, subject: 'Potvrzení o hlasování')
  end
end
