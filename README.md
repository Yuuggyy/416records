# 416 Records — App Flutter avec AdMob

Application du label 416 Records avec système de monétisation par publicités.

## Système de pubs intégré

### 1. Pre-roll (avant chaque vidéo)
- Pub de 10 secondes avant chaque épisode ou vidéo
- Non-skippable pour maximiser le revenu
- eCPM estimé: $5/1000 vues

### 2. Rewarded Ads (contenu exclusif)
- L'utilisateur regarde 30 secondes de pub pour débloquer:
  - Coulisses des épisodes
  - Interviews exclusives
  - Votes bonus
  - Téléchargement de sons
- eCPM estimé: $15/1000 vues (le plus rentable)

### 3. Interstitial (entre les actions)
- Apparaît après un vote, avant les résultats
- 4 coupures pub pendant chaque épisode (mid-rolls)
- eCPM estimé: $5/1000 vues

### 4. Banner (bannière persistante)
- Bannière en bas de l'écran pendant la navigation
- 100% passive
- eCPM estimé: $0.50/1000 vues

## Configuration AdMob

1. Créer un compte AdMob: https://admob.google.com
2. Ajouter l'app et récupérer l'App ID
3. Remplacer les IDs de test dans `lib/core/constants/ad_constants.dart`
4. Mettre à jour `android/app/src/main/AndroidManifest.xml` et `ios/Runner/Info.plist`
5. Passer `useTestAds` à `false` pour la production

## Structure

```
lib/
  core/
    constants/
      ad_constants.dart    # IDs AdMob (test + production)
    services/
      ad_service.dart      # Service central de gestion des pubs
    models/
      episode_model.dart   # Modèles (Episode, Artist, VideoClip)
  presentation/
    screens/
      home/                # Accueil avec liste des épisodes
      episode/             # Lecture d'épisode avec pre-roll + mid-rolls
    widgets/
      ad_banner_widget.dart    # Bannière AdMob
      rewarded_ad_dialog.dart  # Dialog pour rewarded ads
  main.dart                # Initialisation AdMob + Provider
```

## Revenu estimé par utilisateur (3 mois)

| Format        | Vues/jour | eCPM  | Revenu/mois |
|---------------|-----------|-------|-------------|
| Pre-roll      | 2         | $5    | $0.30       |
| Rewarded      | 0.3       | $15   | $0.14       |
| Interstitial  | 1         | $5    | $0.15       |
| Banner        | passive   | $0.50 | $0.02       |
| **Total**     |           |       | **$0.61**   |

Sur 3 mois: ~$1.83 par utilisateur actif

## Installation

```bash
flutter pub get
flutter run
```
