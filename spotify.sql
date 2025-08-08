-- ========================================
-- SPOTIFY DATASET ANALYSIS
-- Understanding What Makes Songs Popular.
-- ========================================
-- Business Objective
/*
Music streaming platforms like Spotify and YouTube have transformed how we discover and consume music. 
For artists, producers and music executives understanding what makes certain tracks perform better than others is crucial for success in today's digital landscape. This SQL analysis project aims to:
1. Identify the characteristics of highly successful songs by analysing audio features (danceability, energy, valence, etc.) platform performance (Spotify streams vs. YouTube views)
   and content type (licensed vs. unlicensed, official videos).
2. Compare platform performance to understand why some songs perform better on Spotify while others dominate on YouTube helping artists optimise their release strategies.
3. Provide actionable insights about music production by revealing which audio features correlate with popularity, helping creators make data-driven decisions about their music.
4. Analyse artist performance to understand what separates top-performing artists from others in terms of productivity, engagement and musical style.
Why This Matters:
For music creators and industry professionals this analysis answers critical questions:
- Should you focus on making danceable tracks or acoustic ballads?
- Is it better to release singles or full albums?
- How important is having an official music video?
- What kind of songs tend to go viral on YouTube versus getting heavy rotation on Spotify?
- Which artists have the most effective strategies that others could learn from?
By examining real data from 20,592 tracks by 2,074 artists we can move beyond guesswork and gut feelings to understand what truly resonates with us listeners today.
*/

-- The dataset was sourced from Kaggle: Link(https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

-- CREATE TABLE STRUCTURE
-- This creates our main table to store all Spotify track data
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),              -- Name of the artist/band
    track VARCHAR(255),               -- Name of the song
    album VARCHAR(255),               -- Album name
    album_type VARCHAR(50),           -- Type: single, album, compilation
    danceability FLOAT,               -- How suitable for dancing (0-1)
    energy FLOAT,                     -- Intensity and power (0-1)
    loudness FLOAT,                   -- Overall loudness in decibels
    speechiness FLOAT,                -- Presence of spoken words (0-1)
    acousticness FLOAT,               -- How acoustic the track is (0-1)
    instrumentalness FLOAT,           -- Predicts if track has no vocals (0-1)
    liveness FLOAT,                   -- Detects presence of audience (0-1)
    valence FLOAT,                    -- Musical positiveness (0-1)
    tempo FLOAT,                      -- Beats per minute
    duration_min FLOAT,               -- Length of track in minutes
    title VARCHAR(255),               -- YouTube video title
    channel VARCHAR(255),             -- YouTube channel name
    views FLOAT,                      -- YouTube views
    likes BIGINT,                     -- YouTube likes
    comments BIGINT,                  -- YouTube comments
    licensed BOOLEAN,                 -- Whether the content is licensed
    official_video BOOLEAN,           -- Whether it's an official music video
    stream BIGINT,                    -- Number of Spotify streams
    energy_liveness FLOAT,            -- Combined energy and liveness score
    most_played_on VARCHAR(50)        -- Platform where it's most popular
);

-- =====================================
-- STEP 1: DATA QUALITY CHECKS
-- =====================================

-- 1.1 CHECK FOR NULL VALUES
-- This helps us understand data completeness across all columns
SELECT 
    'DATA COMPLETENESS CHECK' AS analysis_type,
    COUNT(*) as total_rows,
    COUNT(artist) as artist_count,
    COUNT(track) as track_count,
    COUNT(album) as album_count,
    COUNT(album_type) as album_type_count,
    COUNT(danceability) as danceability_count,
    COUNT(energy) as energy_count,
    COUNT(loudness) as loudness_count,
    COUNT(speechiness) as speechiness_count,
    COUNT(acousticness) as acousticness_count,
    COUNT(instrumentalness) as instrumentalness_count,
    COUNT(liveness) as liveness_count,
    COUNT(valence) as valence_count,
    COUNT(tempo) as tempo_count,
    COUNT(duration_min) as duration_min_count,
    COUNT(title) as title_count,
    COUNT(channel) as channel_count,
    COUNT(views) as views_count,
    COUNT(likes) as likes_count,
    COUNT(comments) as comments_count,
    COUNT(licensed) as licensed_count,
    COUNT(official_video) as official_video_count,
    COUNT(stream) as stream_count,
    COUNT(energy_liveness) as energy_liveness_count,
    COUNT(most_played_on) as most_played_on_count
FROM spotify;
/*
Observations
There are no missing values in the datasets and all record shows they contain each 20,594 records
*/
-- 1.2 CHECK FOR DUPLICATE RECORDS
-- Identifies if the same track appears multiple times
SELECT 
    'DUPLICATE ANALYSIS' AS check_type,
    artist, 
    track, 
    album, 
    COUNT(*) as duplicate_count
FROM spotify 
GROUP BY artist, track, album 
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
/*
Observations
There are no duplicate values
*/

-- 1.3 CHECK FOR DATA QUALITY ISSUES
-- Identifies invalid or suspicious data values
SELECT 
    'DATA QUALITY ISSUES' AS analysis_section,
    issue_type,
    count AS problematic_records
FROM (
    SELECT 'Invalid Duration (<=0 minutes)' as issue_type, COUNT(*) as count
    FROM spotify WHERE duration_min <= 0
    UNION ALL
    SELECT 'Negative Views' as issue_type, COUNT(*) as count
    FROM spotify WHERE views < 0
    UNION ALL
    SELECT 'Negative Streams' as issue_type, COUNT(*) as count
    FROM spotify WHERE stream < 0
    UNION ALL
    SELECT 'Invalid Danceability (not 0-1)' as issue_type, COUNT(*) as count
    FROM spotify WHERE danceability < 0 OR danceability > 1
    UNION ALL
    SELECT 'Invalid Energy (not 0-1)' as issue_type, COUNT(*) as count
    FROM spotify WHERE energy < 0 OR energy > 1
    UNION ALL
    SELECT 'Invalid Valence (not 0-1)' as issue_type, COUNT(*) as count
    FROM spotify WHERE valence < 0 OR valence > 1
) quality_check
ORDER BY count DESC;

/*
Observations
The outputs raises 2 probrematic records i.e Duration <=0, We have to drop those records
*/

-- Delete records with invalid duration (<=0 minutes)
DELETE FROM spotify 
WHERE duration_min <= 0;

-- =============================
-- STEP 2: DATASET EXPLORATION
-- =============================

-- 2.1 DATASET OVERVIEW
-- Provides high-level statistics about our dataset
SELECT 
    'DATASET OVERVIEW' AS analysis_section,
    COUNT(*) AS total_tracks,
    COUNT(DISTINCT artist) AS unique_artists,
    COUNT(DISTINCT album) AS unique_albums,
    COUNT(DISTINCT track) AS unique_tracks,
    COUNT(DISTINCT channel) AS unique_channels,
    ROUND(MIN(duration_min)::numeric, 2) AS shortest_track_minutes,
    ROUND(MAX(duration_min)::numeric, 2) AS longest_track_minutes,
    ROUND(AVG(duration_min)::numeric, 2) AS avg_track_duration_minutes,
    ROUND(MIN(stream)::numeric, 0) AS min_streams,
    ROUND(MAX(stream)::numeric, 0) AS max_streams,
    ROUND(AVG(stream)::numeric, 0) AS avg_streams
FROM spotify;

/*
Observations
-- The dataset shows 20,592 tracks by 2074 arrtists and 11,853 albumns with streams ranging up to 3.3 billion. Most tracks average ~132 million streams—showing a few hits dominate.
*/

-- 2.2 ALBUM TYPE DISTRIBUTION
-- Shows what types of releases are in our dataset
SELECT 
    'ALBUM TYPE DISTRIBUTION' AS analysis_section,
    album_type,
    COUNT(*) AS track_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM spotify), 2) AS percentage_of_total
FROM spotify 
GROUP BY album_type 
ORDER BY track_count DESC;
/* Observations
-- Albums dominate the dataset (72% of tracks), followed by singles (24%) and compilations (4%). This suggests artists focus more on full albums than standalone singles in this collection.
*/
-- 2.3 PLATFORM POPULARITY DISTRIBUTION
-- Shows which platforms tracks are most popular on
SELECT 
    'PLATFORM POPULARITY' AS analysis_section,
    most_played_on AS platform,
    COUNT(*) AS track_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM spotify), 2) AS percentage,
    ROUND(AVG(views)::numeric, 0) AS avg_youtube_views,
    ROUND(AVG(stream)::numeric, 0) AS avg_spotify_streams
FROM spotify 
GROUP BY most_played_on 
ORDER BY track_count DESC;
/*
Observations
-- Spotify dominates as the preferred platform with (76% of tracks) but YouTube videos average 5x more views per track (240M vs Spotify’s 139M streams).
   This suggests artists may prioritise Spotify for distribution while YouTube drives viral reach.
*/
-- 2.4 AUDIO FEATURES ANALYSIS
-- Statistical summary of all audio characteristics
SELECT 
    'AUDIO FEATURES STATISTICS' AS analysis_section,
    feature_name,
    ROUND(min_value::numeric, 4) AS minimum,
    ROUND(max_value::numeric, 4) AS maximum,
    ROUND(avg_value::numeric, 4) AS average,
    ROUND(std_deviation::numeric, 4) AS standard_deviation
FROM (
    SELECT 'Danceability' AS feature_name, MIN(danceability) AS min_value, MAX(danceability) AS max_value, AVG(danceability) AS avg_value, STDDEV(danceability) AS std_deviation FROM spotify
    UNION ALL
    SELECT 'Energy', MIN(energy), MAX(energy), AVG(energy), STDDEV(energy) FROM spotify
    UNION ALL
    SELECT 'Loudness', MIN(loudness), MAX(loudness), AVG(loudness), STDDEV(loudness) FROM spotify
    UNION ALL
    SELECT 'Speechiness', MIN(speechiness), MAX(speechiness), AVG(speechiness), STDDEV(speechiness) FROM spotify
    UNION ALL
    SELECT 'Acousticness', MIN(acousticness), MAX(acousticness), AVG(acousticness), STDDEV(acousticness) FROM spotify
    UNION ALL
    SELECT 'Instrumentalness', MIN(instrumentalness), MAX(instrumentalness), AVG(instrumentalness), STDDEV(instrumentalness) FROM spotify
    UNION ALL
    SELECT 'Liveness', MIN(liveness), MAX(liveness), AVG(liveness), STDDEV(liveness) FROM spotify
    UNION ALL
    SELECT 'Valence', MIN(valence), MAX(valence), AVG(valence), STDDEV(valence) FROM spotify
    UNION ALL
    SELECT 'Tempo', MIN(tempo), MAX(tempo), AVG(tempo), STDDEV(tempo) FROM spotify
    UNION ALL
    SELECT 'Duration_Minutes', MIN(duration_min), MAX(duration_min), AVG(duration_min), STDDEV(duration_min) FROM spotify
) audio_stats
ORDER BY feature_name;
/*
Observations
-- Tracks average upbeat, danceable qualities (valence: 0.53, danceability: 0.62, energy: 0.64) with most under 4 minutes long (avg: 3.74). 
   High instrumentalness variance (0–1) suggests a mix of vocal-heavy and purely instrumental tracks.
*/
-- =====================================
-- STEP 3: FEATURE CORRELATION ANALYSIS
-- =====================================

-- 3.1 AUDIO FEATURES VS POPULARITY CORRELATIONS
-- Shows how audio characteristics relate to track popularity
SELECT 
    'AUDIO FEATURES vs POPULARITY' AS analysis_section,
    correlation_type,
    ROUND(correlation_coefficient::numeric, 4) AS correlation_strength
FROM (
    SELECT 'Danceability vs YouTube Views' AS correlation_type, CORR(danceability, views) AS correlation_coefficient FROM spotify
    UNION ALL
    SELECT 'Energy vs YouTube Views', CORR(energy, views) FROM spotify
    UNION ALL
    SELECT 'Valence vs YouTube Views', CORR(valence, views) FROM spotify
    UNION ALL
    SELECT 'Acousticness vs YouTube Views', CORR(acousticness, views) FROM spotify
    UNION ALL
    SELECT 'Danceability vs Spotify Streams', CORR(danceability, stream) FROM spotify
    UNION ALL
    SELECT 'Energy vs Spotify Streams', CORR(energy, stream) FROM spotify
    UNION ALL
    SELECT 'Valence vs Spotify Streams', CORR(valence, stream) FROM spotify
    UNION ALL
    SELECT 'Duration vs YouTube Views', CORR(duration_min, views) FROM spotify
    UNION ALL
    SELECT 'Duration vs Spotify Streams', CORR(duration_min, stream) FROM spotify
    UNION ALL
    SELECT 'Loudness vs YouTube Views', CORR(loudness, views) FROM spotify
) correlations
ORDER BY ABS(correlation_coefficient) DESC;
/*
Observations
-- Loudness has the strongest positive link to YouTube views (0.12 correlation), suggesting louder tracks perform better visually. 
   Danceability also weakly boosts popularity on both platforms, while acoustic tracks trend slightly negative on YouTube (-0.07).
*/
-- 3.2 INTER-FEATURE CORRELATIONS
-- Shows how audio features relate to each other
SELECT 
    'AUDIO FEATURES RELATIONSHIPS' AS analysis_section,
    feature_relationship,
    ROUND(correlation_value::numeric, 4) AS correlation_strength
FROM (
    SELECT 'Energy vs Loudness' AS feature_relationship, CORR(energy, loudness) AS correlation_value FROM spotify
    UNION ALL
    SELECT 'Danceability vs Valence', CORR(danceability, valence) FROM spotify
    UNION ALL
    SELECT 'Energy vs Acousticness', CORR(energy, acousticness) FROM spotify
    UNION ALL
    SELECT 'Speechiness vs Instrumentalness', CORR(speechiness, instrumentalness) FROM spotify
    UNION ALL
    SELECT 'Liveness vs Energy', CORR(liveness, energy) FROM spotify
    UNION ALL
    SELECT 'Acousticness vs Loudness', CORR(acousticness, loudness) FROM spotify
) feature_correlations
ORDER BY ABS(correlation_value) DESC;
/*
Observations
-- Loudness has the strongest positive link to YouTube views with (0.12 correlation) suggesting louder tracks perform better visually. 
   Danceability also weakly boosts popularity on both platforms while acoustic tracks trend slightly negative on YouTube (-0.07).
*/
-- =====================================
-- STEP 4: CONTENT TYPE ANALYSIS
-- =====================================

-- 4.1 LICENSED VS NON-LICENSED CONTENT PERFORMANCE
-- Compares performance between licensed and non-licensed content
SELECT 
    'LICENSED CONTENT ANALYSIS' AS analysis_section,
    CASE WHEN licensed = TRUE THEN 'Licensed Content' ELSE 'Non-Licensed Content' END AS content_type,
    COUNT(*) AS track_count,
    ROUND(AVG(views::numeric), 0) AS avg_youtube_views,
    ROUND(AVG(likes::numeric), 0) AS avg_youtube_likes,
    ROUND(AVG(comments::numeric), 0) AS avg_youtube_comments,
    ROUND(AVG(stream::numeric), 0) AS avg_spotify_streams
FROM spotify 
GROUP BY licensed
ORDER BY track_count DESC;
/*
Observations
-- Licensed tracks dominate the dataset (14,059 vs 6,533) and significantly outperform non-licensed content across all metrics. 
   On average licensed tracks get:
		-- 4.2x more YouTube views   (121M vs 29M)
		-- 3.6x more YouTube likes   (841K vs 231K)
		-- 4.1x more comments        (35K vs 8.8K)
		-- 1.6x more Spotify streams (150M vs 94M)
*/
-- 4.2 OFFICIAL VIDEO VS NON-OFFICIAL VIDEO PERFORMANCE
-- Compares performance between official and non-official videos
SELECT 
    'OFFICIAL VIDEO ANALYSIS' AS analysis_section,
    CASE WHEN official_video = TRUE THEN 'Official Videos' ELSE 'Non-Official Videos' END AS video_type,
    COUNT(*) AS track_count,
    ROUND(AVG(views::numeric), 0) AS avg_youtube_views,
    ROUND(AVG(likes::numeric), 0) AS avg_youtube_likes,
    ROUND(AVG(comments::numeric), 0) AS avg_youtube_comments,
    ROUND(AVG(stream::numeric), 0) AS avg_spotify_streams
FROM spotify 
GROUP BY official_video
ORDER BY track_count DESC;
/*
Observations
-- Official videos get 5x more engagement.
*/
-- =====================================
-- STEP 5: SPECIFIC QUESTIONS
-- =====================================

-- QUESTION 1: Retrieve the names of all tracks that have more than 1 billion streams
-- This identifies the most successful tracks on Spotify
SELECT 
    'BILLION+ STREAM TRACKS' AS query_type,
    artist,
    track,
    ROUND(stream::numeric, 0) AS spotify_streams,
    ROUND(views::numeric, 0) AS youtube_views,
    album
FROM spotify 
WHERE stream > 1000000000
ORDER BY stream DESC;
/*
Observations
-- We have [Blinding Lights, Shape of You, Someone You Loved, rockstar (feat. 21 Savage) and Sunflower - Spider-Man: Into the Spider-Verse] 
   tracks with 2.5+B streams on spotify and 580+M on Youtube views.
*/
-- QUESTION 2: List all albums along with their respective artists
-- Complete catalog of all albums in our dataset
SELECT 
    'ARTIST-ALBUM CATALOG' AS query_type,
    artist,
    album,
    album_type,
    COUNT(*) AS tracks_in_album
FROM spotify 
GROUP BY artist, album, album_type
ORDER BY artist, album;
/*Observation
-- Most albums contain just 1-2 tracks which suggesting artists frequently release short-form projects or singles rather than traditional full-length albums.
*/
-- QUESTION 3: Get the total number of comments for tracks where licensed = TRUE
-- Total engagement for licensed content
SELECT 
    'LICENSED CONTENT ENGAGEMENT' AS query_type,
    SUM(comments) AS total_comments_licensed,
    COUNT(*) AS licensed_tracks,
    ROUND(AVG(comments), 0) AS avg_comments_per_licensed_track
FROM spotify 
WHERE licensed = TRUE;
/*
Observation
-- Licensed tracks generate massive engagement with nearly 500 million total YouTube comments across 14,059 tracks - that's about 35,000 comments per track on average.
*/
-- QUESTION 4: Find all tracks that belong to the album type 'single'
-- All single releases in our dataset
SELECT 
    'SINGLE RELEASES' AS query_type,
    artist,
    track,
    album,
    ROUND(stream::numeric, 0) AS spotify_streams,
    ROUND(views::numeric, 0) AS youtube_views
FROM spotify 
WHERE album_type = 'single'
ORDER BY stream DESC;
/*
Observation
-- Hits like See You Again (5.7B YouTube views) and Closer (2.4B Spotify streams) show teamwork wins. 
   YouTube loves viral moments and Spotify favors replay value.
*/
-- QUESTION 5: Count the total number of tracks by each artist
-- Artist productivity ranking
SELECT 
    'ARTIST TRACK COUNT' AS query_type,
    artist,
    COUNT(*) AS total_tracks,
    ROUND(AVG(stream::numeric), 0) AS avg_streams_per_track,
    ROUND(AVG(views::numeric), 0) AS avg_views_per_track,
    ROUND(SUM(stream), 0) AS total_artist_streams
FROM spotify 
GROUP BY artist 
ORDER BY total_tracks DESC, total_artist_streams DESC;
/*
Observation
-- Post Malone tops Spotify (1.5B avg streams/track) and Ed Sheeran rules YouTube (1.55B avg views). All artists here have exactly 10 tracks proving hit quality beats quantity.
*/
-- QUESTION 6: Calculate the average danceability of tracks in each album
-- Album danceability analysis
SELECT 
    'ALBUM DANCEABILITY ANALYSIS' AS query_type,
    artist,
    album,
    COUNT(*) AS tracks_in_album,
    ROUND(AVG(danceability::numeric), 3) AS avg_danceability,
    ROUND(AVG(energy::numeric), 3) AS avg_energy,
    ROUND(AVG(valence::numeric), 3) AS avg_valence
FROM spotify 
GROUP BY artist, album 
HAVING COUNT(*) > 1  -- Only albums with multiple tracks
ORDER BY avg_danceability DESC
Limit 15;
/*
Observation
-- Megan Thee Stallion & Coi Leray dominate with 95%+ danceability scores. Kids' songs (Super Simple Songs) show surprisingly high danceability (94%) and positivity (92% valence).
*/
-- QUESTION 7: Find the top 5 tracks with the highest energy values
-- Most energetic tracks in the dataset
SELECT 
    'HIGHEST ENERGY TRACKS' AS query_type,
    artist,
    track,
    ROUND(energy::numeric, 3) AS energy_score,
    ROUND(danceability::numeric, 3) AS danceability_score,
    ROUND(loudness::numeric, 1) AS loudness_db,
    ROUND(stream::numeric, 0) AS spotify_streams
FROM spotify 
ORDER BY energy DESC;
/*
Observation
-- Rain Frruits sounds dominate 'highest energy' tracks with (1.0 score each) but are actually quiet (-25dB) and undanceable. 
   Streaming numbers (15M+ each) reveal strong demand for sleep/study content
*/
-- QUESTION 8: List all tracks along with their views and likes where official_video = TRUE
-- All official music videos and their performance
SELECT 
    'OFFICIAL MUSIC VIDEOS' AS query_type,
    artist,
    track,
    album,
    ROUND(views::numeric, 0) AS youtube_views,
    likes AS youtube_likes,
    comments AS youtube_comments,
    ROUND(stream::numeric, 0) AS spotify_streams,
    channel AS youtube_channel
FROM spotify 
WHERE official_video = TRUE
ORDER BY views DESC;
/*
Obserrvations
-- Despacito (8B+ views) dominates, but CoComelon’s kids' videos (Wheels on the Bus: 4.9B views) outperform most pop stars."
   On other hands YouTube vs. Spotify Gap: See You Again (5.8B YouTube) vs. (1.5B Spotify) and Shape of You (5.9B YouTube) vs. (3.4B Spotify)
*/
-- QUESTION 9: For each album, calculate the total views of all associated tracks
-- Album-level YouTube performance
SELECT 
    'ALBUM YOUTUBE PERFORMANCE' AS query_type,
    artist,
    album,
    COUNT(*) AS tracks_in_album,
    ROUND(SUM(views::numeric), 0) AS total_album_views,
    ROUND(AVG(views::numeric), 0) AS avg_views_per_track,
    ROUND(SUM(likes::numeric), 0) AS total_album_likes,
    ROUND(SUM(stream::numeric), 0) AS total_album_streams
FROM spotify 
GROUP BY artist, album 
ORDER BY total_album_views DESC;
/* 
Observations
-- Luis Fonsi's VIDA dominates with 10.8B total views (2.7B per track) blending massive singles (Despacito) with strong supporting tracks.
-- Kids vs. Music Stars:
     - CoComelon ranks #2 (10.5B views) with just 197M Spotify streams showing YouTube's kid-content advantage.
     - Music albums (÷, PRISM) average 3x more Spotify streams than kids' content.
-- Efficiency Wins:
    - Daddy Yankee's VIDA (1-track) earns 8B views proving sometimes less is more.
    - Most top albums have <= 4 tracks suggesting focused releases outperform large collections.
*/

-- QUESTION 10: Retrieve tracks streamed more on Spotify than viewed on YouTube
-- Tracks that perform better on Spotify than YouTube
SELECT 
    'SPOTIFY > YOUTUBE PERFORMANCE' AS query_type,
    artist,
    track,
    ROUND(stream::numeric, 0) AS spotify_streams,
    ROUND(views::numeric, 0) AS youtube_views,
    ROUND((stream::numeric - views::numeric), 0) AS spotify_advantage,
    ROUND(((stream::numeric - views::numeric) / stream * 100), 1) AS spotify_dominance_percent
FROM spotify 
WHERE stream > views
ORDER BY spotify_advantage DESC;
/*
Observations
-- Spotify dominates for replayable hits like Blinding Lights by (The Weeknd) that has 2.7+B more streams than YouTube views. 
   Some tracks like Love Yourself by (Bieber) are 100% Spotify focused while remixes (Roses) thrive there too. YouTube wins for visuals, Spotify for playlists.
*/

-- QUESTION 11: Find the top 3 most-viewed tracks for each artist using window functions
-- Top performing tracks per artist
WITH artist_track_rankings AS (
    SELECT 
        artist,
        track,
        views,
        stream,
        ROW_NUMBER() OVER (PARTITION BY artist ORDER BY views DESC) AS view_rank
    FROM spotify
)
SELECT 
    'TOP 3 TRACKS PER ARTIST' AS query_type,
    artist,
    track,
    view_rank,
    ROUND(views::numeric, 0) AS youtube_views,
    ROUND(stream::numeric, 0) AS spotify_streams
FROM artist_track_rankings 
WHERE view_rank <= 3
ORDER BY artist, view_rank;
/*
Observation
-- Hip-hop thrives on Spotify, K-Pop excels on both, and remixes maintain YouTube consistency but vary on streams.
*/
-- QUESTION 12: Find tracks where the liveness score is above average
-- Tracks with above-average live performance feel
WITH liveness_benchmark AS (
    SELECT AVG(liveness) AS avg_liveness_score
    FROM spotify
)
SELECT 
    'ABOVE AVERAGE LIVENESS' AS query_type,
    s.artist,
    s.track,
    ROUND(s.liveness::numeric, 3) AS liveness_score,
    ROUND(l.avg_liveness_score::numeric, 3) AS dataset_avg_liveness,
    ROUND((s.liveness::numeric - l.avg_liveness_score::numeric), 3) AS liveness_difference,
    ROUND(s.energy::numeric, 3) AS energy_score
FROM spotify s
CROSS JOIN liveness_benchmark l
WHERE s.liveness > l.avg_liveness_score
ORDER BY s.liveness DESC;
/*
Observation
-- Live tracks especially Latin performances dominate with near perfect liveness scores (Manu Chao: 1.0). Most combine high energy (avg 0.77) except emotional ballads (Franco De Vita: 0.51 energy).
*/
-- QUESTION 13: Calculate the difference between highest and lowest energy values for each album
-- Energy range analysis within albums
WITH album_energy_analysis AS (
    SELECT 
        artist,
        album,
        COUNT(*) AS track_count,
        ROUND(MAX(energy::numeric), 3) AS max_energy,
        ROUND(MIN(energy::numeric), 3) AS min_energy,
        ROUND(AVG(energy::numeric), 3) AS avg_energy,
        ROUND(STDDEV(energy::numeric), 3) AS energy_std_dev
    FROM spotify 
    GROUP BY artist, album
)
SELECT 
    'ALBUM ENERGY RANGE ANALYSIS' AS query_type,
    artist,
    album,
    track_count,
    max_energy,
    min_energy,
    ROUND((max_energy - min_energy), 3) AS energy_range,
    avg_energy,
    energy_std_dev
FROM album_energy_analysis
WHERE track_count > 1  -- Only albums with multiple tracks
ORDER BY energy_range DESC;
/*
Observvation
-- Albums with the widest energy ranges (e.g., UNDERTALE Soundtrack at 0.82) mix high-intensity and calm tracks while artists like Cascada and Disturbed hit peak energy (0.97+) but with less consistency.
*/
-- ===================================================
-- STEP 6. MUSIC CHARACTERISATION & ARTIST PERFORMANCE
-- ===================================================

-- 6.1: GENRE CLASSIFICATION BASED ON AUDIO FEATURES
-- Creates music categories based on audio characteristics
SELECT 
    'MUSIC STYLE CLASSIFICATION' AS analysis_section,
    music_style,
    COUNT(*) AS track_count,
    ROUND(AVG(views::numeric), 0) AS avg_youtube_views,
    ROUND(AVG(stream::numeric), 0) AS avg_spotify_streams,
    ROUND(AVG(danceability::numeric), 3) AS avg_danceability,
    ROUND(AVG(energy::numeric), 3) AS avg_energy,
    ROUND(AVG(valence::numeric), 3) AS avg_valence
FROM (
    SELECT *,
        CASE 
            WHEN danceability > 0.7 AND energy > 0.7 THEN 'High Energy Dance'
            WHEN danceability > 0.7 AND energy <= 0.7 THEN 'Moderate Dance'
            WHEN acousticness > 0.7 THEN 'Acoustic'
            WHEN speechiness > 0.33 THEN 'Spoken Word/Rap'
            WHEN instrumentalness > 0.5 THEN 'Instrumental'
            WHEN valence > 0.7 AND energy > 0.6 THEN 'Happy/Upbeat'
            WHEN valence < 0.3 THEN 'Sad/Melancholic'
            WHEN energy > 0.8 THEN 'High Energy Rock/Pop'
            WHEN energy < 0.3 AND acousticness > 0.5 THEN 'Ambient/Chill'
            ELSE 'Balanced Pop/Rock'
        END AS music_style
    FROM spotify
) categorised_music
GROUP BY music_style
ORDER BY track_count DESC;
/*
Observation
-- High Energy Dance tracks lead in popularity (avg 138M YouTube views, 149M Spotify streams).
-- Sad/Melancholic songs perform surprisingly well on Spotify (avg 156M streams).
-- Acoustic/Instrumental styles have niche appeal, with lower overall numbers.
*/
-- 6.2: STREAMING SUCCESS OUTLIER ANALYSIS
-- Identifies tracks that perform exceptionally well or poorly
WITH streaming_statistics AS (
    SELECT 
        AVG(stream) AS avg_streams,
        STDDEV(stream) AS std_streams
    FROM spotify
)
SELECT 
    'STREAMING OUTLIER ANALYSIS' AS analysis_section,
    s.artist,
    s.track,
    ROUND(s.stream, 0) AS spotify_streams,
    ROUND(st.avg_streams, 0) AS dataset_avg_streams,
    ROUND(((s.stream - st.avg_streams) / st.std_streams), 2) AS z_score,
    CASE 
        WHEN (s.stream - st.avg_streams) / st.std_streams > 2 THEN 'Exceptional Success'
        WHEN (s.stream - st.avg_streams) / st.std_streams < -2 THEN 'Below Average Performance'
        ELSE 'Normal Performance'
    END AS performance_category
FROM spotify s
CROSS JOIN streaming_statistics st
WHERE ABS((s.stream - st.avg_streams) / st.std_streams) > 1.5
ORDER BY z_score DESC;
/*
Observation
-- The Weeknd's Blinding Lights leads with 3.39B streams (13x above average).
-- Ed Sheeran (Shape of You) and Lewis Capaldi (Someone You Loved) follow closely.
-- All top tracks are collabs/soundtracks, proving teamwork drives record-breaking streams.
*/
-- 6.3: ARTIST PERFORMANCE
-- Artist performance dashboard
SELECT 
    'ARTIST PERFORMANCE SUMMARY' AS analysis_section,
    artist,
    COUNT(*) AS total_tracks,
    ROUND(AVG(stream::numeric), 0) AS avg_streams_per_track,
    ROUND(SUM(stream::numeric), 0) AS total_artist_streams,
    ROUND(AVG(views::numeric), 0) AS avg_youtube_views,
    ROUND(AVG(danceability::numeric), 3) AS avg_danceability,
    ROUND(AVG(energy::numeric), 3) AS avg_energy,
    ROUND(AVG(valence::numeric), 3) AS avg_valence,
    COUNT(CASE WHEN official_video = TRUE THEN 1 END) AS official_videos,
    COUNT(CASE WHEN licensed = TRUE THEN 1 END) AS licensed_tracks
FROM spotify 
GROUP BY artist 
HAVING COUNT(*) >= 2  -- Artists with at least 2 tracks
ORDER BY total_artist_streams DESC 
LIMIT 20;

/*
Observation
-- Post Malone leads with 1.53B avg streams/track, followed by Ed Sheeran (1.44B) and Dua Lipa (1.34B).
-- Ed Sheeran dominates YouTube (1.55B avg views), while XXXTENTACION excels on Spotify despite lower views.
-- Dua Lipa has the highest danceability (0.75), while Billie Eilish succeeds with low-energy, moody tracks.
*/
-- =====================================
-- STEP 7: SUMMARY
-- =====================================

-- 7.1 Key dataset insights
SELECT 
    'DATASET INSIGHTS' AS final_analysis,
    'Total Tracks' AS metric,
    COUNT(*)::VARCHAR AS value
FROM spotify
UNION ALL
SELECT 
    'DATASET INSIGHTS',
    'Unique Artists',
    COUNT(DISTINCT artist)::VARCHAR
FROM spotify
UNION ALL
SELECT 
    'DATASET INSIGHTS',
    'Avg Track Duration (minutes)',
    ROUND(AVG(duration_min::numeric), 2)::VARCHAR
FROM spotify
UNION ALL
SELECT 
    'DATASET INSIGHTS',
    'Most Common Album Type',
    (SELECT album_type FROM spotify GROUP BY album_type ORDER BY COUNT(*) DESC LIMIT 1)
FROM spotify
UNION ALL
SELECT 
    'DATASET INSIGHTS',
    'Highest Streamed Track',
    (SELECT CONCAT(artist, ' - ', track) FROM spotify ORDER BY stream DESC LIMIT 1)
FROM spotify
UNION ALL
SELECT 
    'DATASET INSIGHTS',
    'Most Viewed Track',
    (SELECT CONCAT(artist, ' - ', track) FROM spotify ORDER BY views DESC LIMIT 1)
FROM spotify;
/* Observation
- 20,592 tracks from 2,074 unique artists, averaging 3.74 minutes per track and of course albums dominate as the most common release format
*/


-- =============
--  CONCLUSION
-- ==============
/*
The music industry is no longer just about talent it’s about understanding listener behavior. Artists and producers can use these insights to:
- Optimise releases (Spotify for streams, YouTube for virality)
- Focus on high-energy, danceable tracks for broader appeal
- Invest in licensed, official content for maximum reach
- Analyse trends to stay ahead in a competitive market
Music will always be an art, by blending creativity with analytics, artists can craft songs that not only just sound good but also they perform exceptionally.
The future of hits? It’s not just what sounds good—it’s what the data says works. 🎵
*/
-- =====================================
-- END OF ANALYSIS
-- =====================================