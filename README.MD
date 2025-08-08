# Spotify Dataset Analysis

## Project Overview

This SQL analysis project examines a dataset of 20,592 tracks by 2,074 artists to understand the characteristics that contribute to a song's popularity on streaming platforms like Spotify and YouTube. The analysis focuses on audio features, platform performance, content type, and artist strategies to provide actionable insights for music creators and industry professionals.

## Dataset Source

The dataset was sourced from Kaggle: [Spotify Dataset on Kaggle](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

## Key Questions Addressed

1. What audio features (danceability, energy, valence, etc.) correlate with popularity?
2. How do songs perform differently on Spotify vs YouTube?
3. Does licensed content or official videos impact performance?
4. What separates top-performing artists from others?
5. Should artists focus on singles or albums for better reach?

## Analysis Structure

### 1. Data Quality Checks
- Verified data completeness (no null values)
- Identified and removed invalid records (tracks with duration <=0 minutes)
- Checked for duplicate records

### 2. Dataset Exploration
- Basic statistics about tracks, artists, and albums
- Album type distribution (72% albums, 24% singles, 4% compilations)
- Platform popularity (76% of tracks most popular on Spotify)

### 3. Feature Correlation Analysis
- Examined relationships between audio features and popularity
- Identified loudness as having the strongest positive correlation with YouTube views (0.12)
- Found danceability weakly boosts popularity on both platforms

### 4. Content Type Analysis
- Licensed tracks significantly outperform non-licensed content (4.2x more YouTube views, 1.6x more Spotify streams)
- Official videos generate 5x more engagement than non-official videos

### 5. Specific Questions
- Identified billion+ stream tracks (e.g., "Blinding Lights", "Shape of You")
- Analyzed artist productivity and performance
- Examined album-level energy characteristics
- Compared Spotify vs YouTube performance

### 6. Music Characterization & Artist Performance
- Classified tracks into music styles based on audio features
- Identified streaming outliers (exceptional successes and underperformers)
- Created artist performance dashboards

## Key Findings

1. **Platform Preferences**: Spotify dominates as the preferred platform (76% of tracks), but YouTube videos average 5x more views per track.

2. **Audio Features**: Tracks average upbeat, danceable qualities (valence: 0.53, danceability: 0.62, energy: 0.64) with most under 4 minutes long.

3. **Content Type Impact**: Licensed tracks get 4.2x more YouTube views and 1.6x more Spotify streams than non-licensed content.

4. **Top Performers**: 
   - "Blinding Lights" by The Weeknd leads with 3.39B Spotify streams
   - "Despacito" by Luis Fonsi dominates YouTube with 8B+ views
   - Post Malone leads artists with 1.53B average streams per track

5. **Release Strategy**: Albums dominate the dataset (72% of tracks), but focused releases with <=4 tracks often outperform large collections.

## Business Implications

1. Artists should prioritize licensed, official content for maximum reach.
2. High-energy, danceable tracks tend to have broader appeal across platforms.
3. YouTube offers greater viral potential, while Spotify provides more consistent streaming.
4. Collaboration tracks and soundtrack placements often drive record-breaking performance.
5. Quality (hit potential) generally beats quantity (number of tracks released).

## Technical Implementation

The analysis was conducted using SQL with:
- Data quality checks and cleaning
- Statistical analysis and correlation calculations
- Window functions for ranking and comparison
- Conditional logic for music style classification
- Performance metrics
  
##### Query
```sql
-- Statistics about our dataset
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
```

---

## Conclusion

This analysis demonstrates how data-driven insights can complement artistic creativity in the modern music industry. By understanding what resonates with listeners across platforms, artists and producers can make informed decisions about music production, release strategies, and platform optimization.

## Contributing

Contributions are welcome, If you have suggestions for improvements or find any issues, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact


For inquiries or feedback, please reach out to [muthominicholus22@gmail.com].
