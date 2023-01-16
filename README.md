# masto-bookmark-to-nb

Pulls down mastodon bookmarks and store them in nb

https://xwmx.github.io/nb/#-git-sync

On Mastodon, go to Preference / Development, choose "New Application."
Call it "Bookmark Grabber" or something.  Copy "Your Access Token"
and put it in a file called access_token in the same directory
as this Bookmark Grabber.

By default, saves bookmarks in a separate notebook named "mast".
Create that notebook, or else edit the file to change the default.

nb already ignores duplicate bookmarks, so there's no mechanism
to check whether a bookmark is a dupe before trying to save it.

If a bookmarked toot contains a link, this script will make bookmarks
both for the toot itself and the link.

Right now it just grabs the last 20 bookmarks.  So run this at least
once for every 20 bookmarks you save on Mastodon I guess

TODO: do something nice with media

TODO: dealing with the possibility of more than 20 bookmarks

TODO: maybe deal with multiple mastodon accounts

TODO: maybe take tags on the post and turn them into tags
on the bookmark
