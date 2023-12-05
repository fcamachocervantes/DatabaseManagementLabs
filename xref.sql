CREATE TABLE spotify_artists_chart_xref(
    chart_track_id TEXT,
    chart_name TEXT,
    artists_name TEXT,
    PRIMARY KEY (chart_track_id, chart_name, artists_name),
    FOREIGN KEY (chart_track_id, chart_name)
        REFERENCES spotify_chart(track_id, name),
    FOREIGN KEY (artists_name)
        REFERENCES spotify_artists(name)
);