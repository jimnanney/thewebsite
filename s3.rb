require 'aws-sdk'

module S3
  def self.upload(blob, key, opts)
    #File.open "tmp", "wb" do |f| f.write blob end
    #io = StringIO.new blob
    object = bucket.objects[key]

    object.write(blob, {:acl => :public_read, :cache_control => "public, max-age=3600"}.merge(opts))
  end

  def self.bucket
     @s3 ||= AWS::S3.new({
      :access_key_id     => ENV['AWS_ACCESS_KEY'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    })
    @s3.buckets['bearcampruby']
  end
end
