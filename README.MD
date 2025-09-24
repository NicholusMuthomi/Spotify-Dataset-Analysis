# Spotify Dataset Analysis

## Project Overview

The project analyses the Spotify dataset sourced from Kaggle which contains over 20,000 tracks by more than 2,000 artists. The dataset includes both descriptive details like track name, artist, album and genre, as well as numerical features such as tempo, loudness, danceability, energy and popularity.

The main goal of this project is to understand what makes songs popular by studying audio features, streaming performance and platform differences between Spotify and YouTube.

## Business Objective

* Identify patterns in audio features that influence song popularity.
* Compare performance across platforms (Spotify vs YouTube).
* Assess the impact of licensing and official music videos on engagement.
* Explore artist, album and track-level performance.
* Provide insights that can help artists and producers optimise their music strategy.

## Dataset

* Source: [Kaggle Spotify Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)
* Records: 20,592 tracks
* Artists: 2,074
* Features include:

  * Artist, Track, Album, Album Type
  * Danceability, Energy, Loudness, Valence, Tempo, Duration
  * YouTube stats (Views, Likes, Comments)
  * Spotify streams
  * Content type (Licensed, Official Video)

## Environment and Tools

* **Database**: PostgreSQL
* **Interface**: pgAdmin4
* **SQL Script**: `spotify.sql`

## Setup and Usage

1. Install PostgreSQL and pgAdmin4.
2. Open pgAdmin4 and create a new database ( `spotify_db`).
3. Import the dataset into a table, or let the provided SQL script create the schema.
4. Open `spotify.sql` in pgAdmin4.
5. Execute the script section by section to:

   * Create the table.
   * Import the dataset
   * Run data quality checks.
   * Perform exploratory and performance analysis.
   * Generate insights about tracks, albums and artists.

## Analysis Steps

1. **Data Quality Checks**

   * Checked for missing values, duplicates and invalid records.
   * Removed tracks with invalid durations.

2. **Dataset Exploration**

   * High-level statistics on tracks, artists, albums.
   * Album type distribution and platform popularity.

3. **Content Analysis**

   * Licensed vs Non-licensed performance.
   * Official vs Non-official video engagement.

4. **Audio Features Correlation**

   * Studied how danceability, energy, valence and loudness correlate with popularity.
   * Checked inter-feature correlations like energy vs loudness and acousticness vs energy.

5. **Music Characterization**

   * Classified tracks into categories such as High Energy Dance, Acoustic, Sad/Melancholic, etc.

6. **Track and Album Performance**

   * Top billion-stream tracks.
   * Spotify vs YouTube dominance.
   * Album-level engagement, energy ranges and danceability trends.

7. **Artist Analysis**

   * Top-performing artists by total streams and views.
   * Artist performance summaries with average streams, energy and danceability.

8. **Streaming Success and Engagement**

   * Outlier analysis for exceptional tracks.
   * Engagement differences across licensed content and official music videos.
   * High-energy tracks and their audience appeal.

## Findings

* **Spotify dominates distribution** but YouTube often drives higher views per track.
* **Licensed and official content** outperform across all metrics.
* **High-energy, danceable tracks** generally attract larger audiences.
* **Sad/Melancholic songs** show strong Spotify performance.
* **Post Malone, Ed Sheeran and Dua Lipa** emerge as standout artists in streams and views.
* **Top hits dominate streams**, with billions of plays concentrated among a few tracks.

## Conclusion

Streaming success depends not only on the music itself but also on strategic choices like platform focus, licensing and video content. Artists and producers who analyse these trends can optimise releases, focus on high-engagement content and adapt to evolving listener preferences.

## Files

* `spotify.sql` – SQL queries for analysis.
