#!/bin/bash


# Block sites on Xubuntu 20.04.2 (XFCE4)
# https://www.2daygeek.com/linux-etc-hosts-file-block-certain-website-access-on-linux/
# http://blog.sudobits.com/2012/01/13/how-to-block-a-website-domain-in-ubuntu/

# Install nscd first:
# sudo apt install nscd

# Prepare a list of websites you want to block (Note: create a text file as a backup).
# Truncate the domain by stripping down the https:// or http:// part at the beginning.
# For example, https://www.anastysocialmediaplatform.com will become www.anastysocialmediaplatform.com
# Make sure the site doesn't have other domains,
# E.g., https://anastysocialmediaplatform.com or, https://m.anastysocialmediaplatform.com or even,
# https://query.anastysocialmediaplatform.com/lookup
# In the last instance of the same site, any character after the slash '/' character
# should also be truncated, here it should look like: query.anastysocialmediaplatform.com
# Any 'slash' ('/') will not remain at the end of the line, https://web.chatapp.com/ -> web.chatapp.com
# The four domain names associated with the same site would look somewhat like the following lines:
# https://www.anastysocialmediaplatform.com -> www.anastysocialmediaplatform.com
# https://anastysocialmediaplatform.com -> anastysocialmediaplatform.com
# https://m.anastysocialmediaplatform.com -> m.anastysocialmediaplatform.com
# https://query.anastysocialmediaplatform.com/lookup -> query.anastysocialmediaplatform.com

# Open /etc/hosts with your favourite text editor and add each domain to separate lines.
# (Look at the examples provided below).
# sudo mousepad /etc/hosts
# Close the editor.
# Restart the 'nscd' service.
# sudo /etc/init.d/nscd restart

# Run only once: Ref: https://www.delftstack.com/howto/linux/how-to-copy-files-and-directories-using-linux-terminal/
sudo cp -i -v "/etc/hosts" "/etc/hosts.backup.txt" && \
# Type n and hit Enter if you don't want to overwrite an already existing backup.
sudo mousepad /etc/hosts && \


# Examples:

# Filename with full path: /etc/hosts
# Contents:

# # # # # # # # ## # ## # ## # ## # ## # ## # ## # ## # ## # ## # ## # ## # ## # #


# # # # # # # # # # # # # # # # #
# Sites that are on my blocklist
# # # # # # # # # # # # # # # # #
# Don't forget to clean up the whitespaces before 0.0.0.0 and 127.0.0.1
# # # # # # # # # # # # # # # # #
# 	0.0.0.0 www.microblogger.com
# 	127.0.0.1 www.microblogger.com
# 	0.0.0.0 microblogger.com
# 	127.0.0.1 microblogger.com
# 	0.0.0.0 m.microblogger.com
# 	127.0.0.1 m.microblogger.com
# 	0.0.0.0 m.socailmedia.com
# 	127.0.0.1 m.socailmedia.com
# 	0.0.0.0 www.socailmedia.com
# 	127.0.0.1 www.socailmedia.com
# 	0.0.0.0 web.chatapp.com
# 	127.0.0.1 web.chatapp.com
# 	0.0.0.0 www.searchengine.com
# 	127.0.0.1 www.searchengine.com
# 	0.0.0.0 searchengine.com
# 	127.0.0.1 searchengine.com
# 	0.0.0.0 m.searchengine.com
# 	127.0.0.1 m.searchengine.com
# 	0.0.0.0 login.searchengine.com
# 	127.0.0.1 login.searchengine.com
# 	0.0.0.0 finance.searchengine.com
# 	127.0.0.1 finance.searchengine.com
# 	0.0.0.0 search.searchengine.com
# 	127.0.0.1 search.searchengine.com
# 	0.0.0.0 finance.searchengine.com
# 	127.0.0.1 finance.searchengine.com
# 	0.0.0.0 searchengine.com
# 	127.0.0.1 searchengine.com
# 	0.0.0.0 search.searchengine.com
# 	0.0.0.0 news.searchengine.com
# 	127.0.0.1 news.searchengine.com
# 	0.0.0.0 in.searchengine.com
# 	127.0.0.1 in.searchengine.com
# 	0.0.0.0 www.classifiedfraudad.com
# 	127.0.0.1 www.classifiedfraudad.com
# 	0.0.0.0 classifiedfraudadstuff.com
# 	127.0.0.1 classifiedfraudadstuff.com
# 	0.0.0.0 delhi.classifiedfraudad.com
# 	127.0.0.1 delhi.classifiedfraudad.com
# 	0.0.0.0 www.saleyoursoul.in
# 	127.0.0.1 www.saleyoursoul.in
# 	0.0.0.0 www.saleyoursoul.com
# 	127.0.0.1 www.saleyoursoul.com
# 	0.0.0.0 www.xxximmatureporn.com
# 	127.0.0.1 www.xxximmatureporn.com
# 	0.0.0.0 www.antagonistnationtoday.in
# 	127.0.0.1 www.antagonistnationtoday.in
# 	0.0.0.0 www.hatetimes.com
# 	127.0.0.1 www.hatetimes.com
# 	0.0.0.0 www.fakenews.com
# 	127.0.0.1 www.fakenews.com
# 	0.0.0.0 www.antipathyherald.com
# 	127.0.0.1 www.antipathyherald.com
# 	0.0.0.0 www.virulencepost.com
# 	127.0.0.1 www.virulencepost.com
# 	0.0.0.0 www.sociopathicoffsprings.com
# 	127.0.0.1 www.sociopathicoffsprings.com



# # # # # # # # ## # ## # ## # ## # ## # ## # ## # ## # ## # ## # ## # ## # ## # #


sudo /etc/init.d/nscd restart \

# Enjoy an uninterrupted internet experience in the absence of unwanted sites.
### Block ###
# 01. 'AntiSocial' Media platforms
# 02. Advertisement Platforms for Classified Cheaters
# 03. Rumour Monger News Giants
# 04. Websites that vigorously spew Religious Venom
# 05. Distracting Chat App Platforms that are 'detrimental to 'mental health
# 06. Promoters of Hate, Crime, Cruelty, Discrimination, Supremacy, Racism, Bigotry
# or Patrons of Enjoyers of Brutality
# 07. Obnoxious Political Societies
# 08. Corporate Conspirators
# 09. Pornographic Contents
# 10. E-Commerce Platforms
# 11. And, so on...
### Reclaim your SERENITY & FREEDOM! ###
