class ArtistsController < ApplicationController
  def index
    @artists = Artist.all
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def new
    if params[:song_id] && !Song.exists?(params[:song_id])
      redirect_to songs_path
    else
      @artist = Artist.new(song_id: params[:song_id])
    end
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      redirect_to @artist
    else
      render :new
    end
  end

  def edit
    if params[:song_id]
      song = Song.find_by(id: params[:song_id])
      if song.nil?
        redirect_to songs_path, alert: "Song not found."
      else
        @artist = song.artist.find_by(id: params[:id])
      end
    else
      @artist = Artist.find(params[:id])
    end
  end

  def update
    @artist = Artist.find(params[:id])

    @artist.update(artist_params)

    if @artist.save
      redirect_to @artist
    else
      render :edit
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy
    flash[:notice] = "Artist deleted."
    redirect_to artists_path
  end

  private

  def artist_params
    params.require(:artist).permit(:name, :song_id)
  end
end
