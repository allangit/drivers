
import smtplib


content="ejemplo de correo"

mail=smtplib.SMTP("smtp.gmail.com",587)

mail.ehlo()

mail.starttls()

mail.login("descartes640@gmail.com","ramajudan123456789")

mail.sendmail("descartes640@gmail.com","descartes640@hotmail.com", content)

mail.close
