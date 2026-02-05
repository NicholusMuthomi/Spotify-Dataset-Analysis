# Contributing to Spotify Data Analysis

First off, thank you for considering contributing to this project. It's people like you that make this analysis better for everyone interested in music data and streaming analytics.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Submitting Changes](#submitting-changes)
- [Style Guidelines](#style-guidelines)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by a commitment to fostering an open and welcoming environment. By participating, you are expected to uphold this standard. Please be respectful, inclusive, and constructive in all interactions.

### Our Standards

**Examples of behavior that contributes to a positive environment:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Examples of unacceptable behavior:**
- The use of sexualized language or imagery and unwelcome sexual attention or advances
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without explicit permission
- Other conduct which could reasonably be considered inappropriate in a professional setting

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

**Bug Report Template:**
- **Description:** A clear and concise description of what the bug is
- **Steps to Reproduce:** Detailed steps to reproduce the behavior
- **Expected Behavior:** What you expected to happen
- **Actual Behavior:** What actually happened
- **SQL Version:** PostgreSQL version you're using
- **Dataset:** Specify if you're using the original dataset or a modified version
- **Screenshots:** If applicable, add screenshots to help explain your problem
- **Additional Context:** Any other context about the problem

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear Title:** Use a clear and descriptive title
- **Detailed Description:** Provide a step-by-step description of the suggested enhancement
- **Current Behavior:** Explain the current behavior and why it's insufficient
- **Proposed Behavior:** Describe how the enhancement would work
- **Benefits:** Explain why this enhancement would be useful
- **Examples:** If possible, provide examples of how other projects implement similar features

### Areas for Contribution

We welcome contributions in the following areas:

1. **SQL Query Optimization**
   - Improve query performance
   - Add indexes for faster retrieval
   - Optimize complex joins and subqueries

2. **Additional Analysis**
   - Genre-specific deep dives
   - Time-based trend analysis
   - Artist collaboration networks
   - Playlist optimization strategies
   - Predictive modeling for streaming success

3. **Data Visualization**
   - Create visualization scripts (Python, R, Tableau)
   - Generate interactive dashboards
   - Design infographics from analysis results

4. **Documentation**
   - Improve existing documentation
   - Add code comments for complex queries
   - Create tutorials or how-to guides
   - Translate documentation to other languages

5. **Dataset Expansion**
   - Integrate additional data sources
   - Add more recent data
   - Include additional streaming platforms (Apple Music, Amazon Music)

6. **Testing**
   - Add data validation scripts
   - Create test cases for edge scenarios
   - Verify analysis accuracy

## Getting Started

### Prerequisites

Before you begin, ensure you have:
- PostgreSQL 12.x or higher installed
- A SQL client (pgAdmin, DBeaver, or psql)
- Git for version control
- Basic understanding of SQL and music streaming data

### Setting Up Your Development Environment

1. **Fork the Repository**
   ```bash
   # Click the 'Fork' button on GitHub
   ```

2. **Clone Your Fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/Spotify-Data-Analysis.git
   cd Spotify-Data-Analysis
   ```

3. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/NicholusMuthomi/Spotify-Data-Analysis.git
   ```

4. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

5. **Set Up the Database**
   ```sql
   -- Create a test database
   CREATE DATABASE spotify_analysis_dev;
   
   -- Run the schema creation script
   -- Execute the spotify.sql file
   ```

## Development Process

### Branch Naming Convention

Use descriptive branch names that reflect the work being done:

- **Features:** `feature/add-genre-analysis`
- **Bug Fixes:** `fix/correct-streaming-calculation`
- **Documentation:** `docs/update-installation-guide`
- **Performance:** `perf/optimize-artist-query`
- **Refactoring:** `refactor/reorganize-analysis-sections`

### Making Changes

1. **Keep Changes Focused**
   - One feature or fix per pull request
   - Avoid mixing unrelated changes

2. **Write Clear SQL**
   - Use consistent formatting and indentation
   - Add comments explaining complex logic
   - Include descriptive column aliases

3. **Test Your Changes**
   - Verify queries return expected results
   - Check performance with the full dataset
   - Ensure no syntax errors

4. **Update Documentation**
   - Update README.md if functionality changes
   - Add comments to new queries
   - Document any new dependencies

### SQL Style Guidelines

Follow these conventions for consistency:

**Formatting:**
```sql
-- Use uppercase for SQL keywords
SELECT 
    artist,
    track,
    ROUND(AVG(stream)::numeric, 0) AS avg_streams
FROM spotify
WHERE album_type = 'single'
GROUP BY artist, track
ORDER BY avg_streams DESC
LIMIT 10;

-- Use meaningful aliases
SELECT 
    s.artist,
    s.track,
    COUNT(*) AS total_tracks
FROM spotify s
GROUP BY s.artist, s.track;

-- Add section headers for organization
-- =====================================
-- SECTION NAME: DESCRIPTIVE TITLE
-- =====================================
```

**Comments:**
```sql
-- Single-line comment for brief explanations

/*
Multi-line comment for:
- Detailed explanations
- Query purpose
- Expected results
- Business context
*/
```

**Query Organization:**
```sql
-- 1. Clear query purpose at the top
-- 2. Main SELECT statement
-- 3. FROM clause
-- 4. JOIN clauses (if any)
-- 5. WHERE conditions
-- 6. GROUP BY
-- 7. HAVING
-- 8. ORDER BY
-- 9. LIMIT

-- Add observations after each query
/*
Observations:
- Key finding 1
- Key finding 2
- Business implication
*/
```

## Submitting Changes

### Pull Request Process

1. **Update Your Branch**
   ```bash
   git checkout main
   git pull upstream main
   git checkout your-branch-name
   git rebase main
   ```

2. **Push Your Changes**
   ```bash
   git push origin your-branch-name
   ```

3. **Create Pull Request**
   - Go to your fork on GitHub
   - Click "New Pull Request"
   - Select your branch
   - Fill out the PR template

### Pull Request Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Changes Made
- List specific changes
- Include query modifications
- Note any new dependencies

## Testing
- [ ] Tested with full dataset
- [ ] Verified query results
- [ ] Checked performance impact
- [ ] Updated documentation

## Screenshots (if applicable)
Add screenshots of results or visualizations

## Related Issues
Closes #issue_number
```

### Review Process

- All submissions require review before merging
- Reviewers may request changes or ask questions
- Be responsive to feedback and make requested changes
- Once approved, a maintainer will merge your PR

## Style Guidelines

### SQL Code Standards

**DO:**
- Use uppercase for SQL keywords (SELECT, FROM, WHERE)
- Use lowercase for table and column names
- Indent subqueries and complex logic
- Add meaningful comments
- Use descriptive aliases
- Round numeric values appropriately
- Include observation comments after queries

**DON'T:**
- Mix uppercase and lowercase keywords
- Write single-line complex queries
- Use ambiguous aliases (a, b, c, x, y)
- Leave queries without context
- Ignore performance considerations

### Documentation Standards

- Use clear, concise language
- Include examples where helpful
- Keep formatting consistent
- Update table of contents when adding sections
- Proofread for spelling and grammar

### Commit Message Guidelines

Write clear, meaningful commit messages:

**Format:**
```
<type>: <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `perf`: Performance improvements
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```
feat: Add genre-based streaming analysis

Added new query to analyze streaming patterns across different music genres.
Includes genre distribution, average streams per genre, and top tracks by genre.

Closes #42
```

```
fix: Correct duration filter in data cleaning

Changed duration filter from < 0 to <= 0 to properly remove invalid records.
Updated observation comments to reflect the fix.
```

```
docs: Update installation instructions for macOS

Added specific steps for installing PostgreSQL on macOS using Homebrew.
Included troubleshooting section for common installation issues.
```

## Community

### Getting Help

If you need help or have questions:

1. **Check Existing Resources**
   - Read the README.md
   - Review existing issues
   - Check closed pull requests for similar work

2. **Ask Questions**
   - Open a GitHub issue with the "question" label
   - Provide context and what you've already tried
   - Be specific about what you need help with

3. **Discussion Topics**
   - Share interesting findings
   - Propose new analysis directions
   - Discuss methodology improvements

### Recognition

Contributors who make significant contributions will be:
- Listed in the project's contributors section
- Acknowledged in release notes
- Credited in related publications or presentations

## Additional Resources

### Learning Resources
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQL Style Guide](https://www.sqlstyle.guide/)
- [Spotify Web API Documentation](https://developer.spotify.com/documentation/web-api)
- [Music Information Retrieval](https://musicinformationretrieval.com/)

### Useful Tools
- **SQL Clients:** pgAdmin, DBeaver, DataGrip
- **Visualization:** Tableau, Power BI, Python (matplotlib, seaborn)
- **Version Control:** Git, GitHub Desktop
- **Code Formatting:** SQL Formatter, pgFormatter

## Questions?

Feel free to reach out if you have any questions:
- **Email:** muthominicholus22@gmail.com
- **GitHub:** [@NicholusMuthomi](https://github.com/NicholusMuthomi)

Thank you for contributing to Spotify Data Analysis! Your efforts help make music data more accessible and understandable for everyone.

---

**Last Updated:** February 2026
