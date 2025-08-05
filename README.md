# Portal Email Templates

A modern email template build system using MJML + PostCSS for portal email templates.

## Features

- **Single source template** - One MJML template generates all 10 email variants
- **Theme-based customization** - JSON config files define colors, text, and content per template
- **Logo processing** - Automatic conversion of images to data URLs for email compatibility
- **Email client compatibility** - MJML handles cross-client rendering issues
- **Modern CSS processing** - PostCSS with custom properties, nesting, and optimization
- **Build automation** - Generate HTML and JSON outputs for easy integration

## Directory Structure

```
portal-emails/
├── src/
│   └── base-email.mjml          # Base template with Handlebars variables
├── config/                      # JSON config files for each template variant
│   ├── temporaryLoginLink.json
│   ├── versionUpdateAvailable.json
│   └── ...
├── images/                      # Logo and image assets
│   ├── openhands-logo-original.png
│   └── openhands-logo-transparent.png
├── scripts/
│   └── build.js                 # Build script with logo processing
├── dist/                        # Generated HTML files
├── templates/                   # Generated JSON files (original format)
└── postcss.config.js           # PostCSS configuration
```

## Usage

### Install Dependencies

```bash
npm install
```

### Build All Templates

```bash
npm run build
# or
make build
```

This generates:
- `dist/*.html` - Clean HTML files for each template
- `templates/*.json` - Individual JSON files in original format
- `$BUILDDIR/email-templates.json` - Combined JSON file for API integration

### Build Single Template

```bash
npm run build:template templateId
# Example: npm run build:template temporaryLoginLink
```

### Clean Output

```bash
npm run clean
# or
make clean
```

## Configuration

Each template is configured via JSON files in the `config/` directory. Example:

```json
{
  "id": "temporaryLoginLink",
  "subject": "Complete your login to {{app_name}}",
  "logo_url": "images/openhands-logo-transparent.png",
  "header_color": "#000000",
  "accent_color": "#4A90E2", 
  "badge_text": "Ready to Log In",
  "main_title": "You're All Set!",
  // ... more config
}
```

### Available Configuration Options

#### Colors
- `header_color` - Header background color
- `accent_color` - Accent elements (borders, icons)
- `button_color` - Action button background
- `highlight_bg_color` - Content highlight box background

#### Branding
- `logo_url` - Path to logo image (local file or URL)
- `logo_data_url` - Automatically generated data URL (do not set manually)

#### Content
- `badge_text` - Header badge text
- `header_emoji` - Large emoji in header
- `main_title` - Main title text
- `content_icon` - Icon in content highlight box
- `highlight_title` - Title in highlight box
- `highlight_description` - Description text
- `button_text` - Action button text
- `signature_text` - Footer signature

#### Variables
All Handlebars variables (e.g., `{{app_name}}`, `{{login_url}}`) are preserved and passed through to the final templates.

## Logo Processing

The build system automatically processes logos during the build:

1. **Set logo URL**: Add `logo_url` to your JSON config pointing to a local file or HTTP(S) URL
   ```json
   "logo_url": "images/openhands-logo-transparent.png"
   ```

2. **Automatic conversion**: The build script fetches the image and converts it to a data URL

3. **Template rendering**: The logo appears alongside the app name in the header
   - Logo shows if available (40px × 40px, responsive)
   - Falls back to ⚡ emoji if no logo provided

4. **Email compatibility**: Data URLs work in all email clients (no external dependencies)

### Logo Specifications
- **Recommended format**: PNG with transparent background
- **Size**: 40px × 40px (scales to 32px on mobile)
- **Background**: Transparent preferred for clean appearance
- **Location**: Store in `images/` directory for local files

## Email Client Compatibility

The build system is optimized for email clients:

- **CSS inlining** - Critical styles are inlined
- **Custom properties** - Converted to static values at build time
- **Email-safe CSS** - Only email-compatible properties used
- **Responsive design** - Mobile-optimized with media queries
- **Cross-client testing** - Styles tested across major email clients

## Template Consolidation

This system achieves ~85-90% code consolidation by:

- **Shared base structure** - One MJML template for all variants
- **Theme variables** - Colors and content defined in config files
- **Automated processing** - Build system handles CSS variable replacement
- **Consistent patterns** - All templates follow same design system

## Current Branding

All templates are currently styled with OpenHands branding:
- **Primary**: Black (#000000) for headers and buttons
- **Accent**: Blue (#4A90E2) for links and highlights  
- **Background**: Warm beige (#F5F1EB) for overall email background
- **Logo**: OpenHands transparent logo (images/openhands-logo-transparent.png)
- **Success**: Green (#28A745) for positive notifications
- **Warning**: Orange (#FF6B35) for license/warning alerts
- **Error**: Red (#DC3545) for downtime/error alerts

## Email Types

- `newInstance.json` - New instance notifications
- `userInvitation.json` - User invitations
- `licenseExpiration.json` - License renewal reminders
- `instanceDowntime.json` - Service alerts
- `userCreated.json` - New user notifications
- `versionUpdateAvailable.json` - Update notifications
- `temporaryLoginLink.json` - Login links
- `trialSignupVerification.json` - Email verification
- `userJoinedTeam.json` - Team join confirmations
- `trialExistingCustomer.json` - Existing customer notifications

## Development

To add a new template:

1. Create a new JSON config file in `config/`
2. Define colors, content, logo, and variables
3. Run `npm run build` to generate the template
4. The new template will appear in `dist/` and `templates/`

## Build Output

The build system generates:
- `dist/*.html` - Individual HTML files for each template
- `templates/*.json` - Individual JSON files in original format
- `$BUILDDIR/email-templates.json` - Combined JSON file for API integration

## Integration

The generated `email-templates.json` file contains all templates with embedded logos as data URLs, ready for API integration with the same structure and Unicode escaping as the original format.