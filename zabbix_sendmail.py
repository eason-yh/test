#!/usr/bin/env python
#-*- coding: UTF-8 -*-
import smtplib	
import sys
from email.mime.text import MIMEText
from email.header import Header

def send_mail(to_email,subject,message):
    sender = '15028213988@163.com'
    receiver = to_email

    subject = 'python email test'
    smtpserver = 'smtp.163.com'
    username = '15028213988'
    password = 'yinhe19890916'

    msg = MIMEText(message, 'plain', 'utf-8')
    msg['Subject'] = subject
    msg['from'] = sender
    msg['to'] = receiver

    smtp = smtplib.SMTP()
    smtp.connect(smtpserver)
    smtp.login(username, password)
    smtp.sendmail(sender, to_email, msg.as_string())
    smtp.quit()
if __name__ == '__main__':
    send_mail(sys.argv[1],sys.argv[2],sys.argv[3])
