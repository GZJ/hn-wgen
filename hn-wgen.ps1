param (
    [int]$limit = 10,
    [string]$proxy
)

$invokeParams = @{}
if ($proxy) {
    $invokeParams['Proxy'] = $proxy
}
$baseUrl = "https://hacker-news.firebaseio.com/v0"
$topStoriesIds = Invoke-RestMethod -Uri "$baseUrl/topstories.json" @invokeParams
$limitedIds = $topStoriesIds | Select-Object -First $limit

$html = @"
<ul>
{0}
</ul>
"@

$listItems = foreach ($id in $limitedIds) {
    $story = Invoke-RestMethod -Uri "$baseUrl/item/$id.json" @invokeParams
    $title = $story.title
    $url = $story.url
    $commentsUrl = "https://news.ycombinator.com/item?id=$id"
    "<li><a href='$url'>$title</a> [<a href='$commentsUrl'>Comments</a>]</li>"
}

$html = $html -f ($listItems -join "`n")
Write-Output $html
