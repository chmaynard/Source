require 'rss'
require 'open-uri'
require 'yaml'
require 'nokogiri'

Jekyll::Hooks.register :site, :pre_render do |site, payload|
    reading_url = [your-url-for-reading-books]
    read_url = [your-url-for-read-books]

    def get_rss_items(input_url)
        item_list = []
        URI.open(input_url) do |rss|
            feed = RSS::Parser.parse(rss)
            # Add fake virtual documents to the collection
            feed.items.each do |item|
                parsed = Nokogiri::HTML.parse(item.description)

                author = item.description.match(/author:\s*((\w|\s|\.|\/)*)/)[1]
                date_read = item.description.match(/read\s*at:\s*((\d|\/)*)/)[1]
                img_src = parsed.xpath("//img").attr('src').text
                url = parsed.xpath("//a").attr('href').text
                guid = item.link.split('/')[-1].split('?')[0]

                payload = {'title' => item.title,
                            'link' => url,
                            'img_src' => img_src,
                            'date_read' => item.pubDate.to_date,
                            'author' => author,
                            'guid' => guid
                }
                puts item.title
                item_list.append(payload)
            end
        end
        return item_list
    end

    site.data['reading'] = get_rss_items(reading_url)
    site.data['read'] = get_rss_items(read_url)

end
