#!/usr/bin/env bash

ACCESS_TOKEN=`cat access_token`
NOTEBOOK=mast
NB_AUTO_SYNC=0 # don't sync every time we add in case we're adding a lot

# todo: use curl -i to get headers, we'll need to do that to do paging.
# paging information is only available in one header, which looks like:
# link: <https://mas.to/api/v1/bookmarks?max_id=51643>; rel="next", <https://mas.to/api/v1/bookmarks?min_id=81589>; rel="prev"


# curl https://mas.to/api/v1/bookmarks -H "Authorization: Bearer $ACCESS_TOKEN" > bookmarks.json
#cat bookmarks.json | jq -cM '.[]' | head -20 | while read -r LINE

curl https://mas.to/api/v1/bookmarks -H "Authorization: Bearer $ACCESS_TOKEN" \
    | jq -cM '.[]' | head -20 | while read -r LINE
do
    ID=$(echo $LINE | jq -r ".id" )
    URL=$(echo $LINE | jq -r ".url" )
    CREATED_AT=$(echo $LINE | jq -r ".created_at" )
    CONTENT=$(echo $LINE | jq -r ".content")
    CARD_URL=$(echo $LINE | jq -r ".card.url")
    CARD_TITLE=$(echo $LINE | jq -r ".card.title")
    ACCOUNT_ACCT=$(echo $LINE | jq -r ".account.acct")
    ACCOUNT_URL=$(echo $LINE | jq -r ".account.url")

    # TODO: attached images and videos?  found as a list in
    # .media_attachments have a .url, .preview_url, .remote_url,
    # .description it would be nice to pull the media links at least
    # into the CONTENT

    # TODO: how about tags on the post?  parse them and use
    # them as tags?  they're in .tags[] | .name

    CONTENT_MD=$(echo "$CONTENT" | pandoc -t gfm-raw_html)

    nb add bookmark "${NOTEBOOK}:/" ${URL} --tags mastodon,tooted --no-color --excerpt "$CONTENT_MD"
    
    if [ "$CARD_URL" != "null" ]; then
	COMMENT="tooted by ${ACCOUNT_ACCT} at #{URL}"
	nb add bookmark "${NOTEBOOK}:/" ${CARD_URL} --comment "$COMMENT" --no-color --tags mastodon,tooted
    fi
done
nb sync

