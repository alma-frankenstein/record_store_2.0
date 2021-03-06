class Song
  attr_reader :id
  attr_accessor :name, :album_id, :artist_id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @album_id = attributes.fetch(:album_id)
    @artist_id = attributes.fetch(:artist_id)
    @id = attributes.fetch(:id)
  end

  def ==(song_to_compare)
    if song_to_compare != nil
      (self.name() == song_to_compare.name()) && (self.album_id() == song_to_compare.album_id()) && (self.artist_id() == song_to_compare.artist_id())
    else
      false
    end
  end

  def self.all
    returned_songs = DB.exec("SELECT * FROM songs;")
    songs = []
    returned_songs.each() do |song|
      name = song.fetch("name")
      album_id = song.fetch("album_id").to_i
      artist_id = song.fetch("artist_id").to_i
      id = song.fetch("id").to_i
      songs.push(Song.new({:name => name, :album_id => album_id, :id => id, :artist_id => artist_id}))
    end
    songs
  end

  def save
    result = DB.exec("INSERT INTO songs (name, album_id, artist_id) VALUES ('#{@name}', #{@album_id}, #{@artist_id}) RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.find(id)
    song = DB.exec("SELECT * FROM songs WHERE id = #{id};").first
    if song
      name = song.fetch("name")
      album_id = song.fetch("album_id").to_i
      artist_id = song.fetch("artist_id").to_i
      id = song.fetch("id").to_i
      Song.new({:name => name, :album_id => album_id, :id => id, :artist_id => artist_id})
    else
      nil
    end
  end

  def update(name, album_id)
    @name = name
    @album_id = album_id
    @artist_id = artist_id
    DB.exec("UPDATE songs SET name = '#{@name}', album_id = #{@album_id}, artist_id = #{@artist_id} WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM songs WHERE id = #{@id};")
  end

  def self.clear
    DB.exec("DELETE FROM songs *;")
  end

  def self.find_by_album(alb_id)
    songs = []
    returned_songs = DB.exec("SELECT * FROM songs WHERE album_id = #{alb_id};")
    returned_songs.each() do |song|
      name = song.fetch("name")
      id = song.fetch("id").to_i
      artist_id = song.fetch("artist_id").to_i
      songs.push(Song.new({:name => name, :album_id => alb_id, :id => id, :artist_id => artist_id}))
    end
    songs
  end

  def self.find_by_artist(artist_id)
    songs = []
    returned_songs = DB.exec("SELECT * FROM songs WHERE artist_id = #{artist_id};")
    returned_songs.each() do |song|
      name = song.fetch("name")
      id = song.fetch("id").to_i
      album_id = song.fetch("album_id").to_i
      songs.push(Song.new({:name => name, :album_id => album_id, :id => id, :artist_id => artist_id}))
    end
    songs
  end

  def album
    Album.find(@album_id)
  end

  def artist
    Artist.find(@artist_id)
  end
end
