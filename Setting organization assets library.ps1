$TenantName = Read-Host 'Nom du tenant Microsoft 365: '
Connect-PnPOnline -Url "https://$TenantName-admin.sharepoint.com" -UseWebLogin

# Récupérer la liste des bibliothèques d'éléments d'organisation
$listAssetsLibrary = Get-PnPOrgAssetsLibrary

if ($listAssetsLibrary.Count -eq 0) {
    # Si la liste est vide, demander à l'utilisateur de saisir l'URL du site SharePoint
    Write-Host "Aucune bibliothèque d'éléments d'organisation n'a été trouvée."
    Write-Host "Veuillez saisir l'URL du site SharePoint:"
    $siteUrlAssetsLibrary = Read-Host

    # Utiliser l'URL du site SharePoint fournie par l'utilisateur
    Write-Host "URL du site SharePoint: $siteUrlAssetsLibrary"
}
else {
    # Récupérer l'URL du site SharePoint qui héberge les bibliothèques d'éléments d'organisation
    $siteUrlAssetsLibrary = $listAssetsLibrary[0].Context.Url
    Write-Host "URL du site SharePoint qui héberge les bibliothèques d'éléments d'organisation: $siteUrlAssetsLibrary"
}

Write-Host "Création d'une bibliothèque d'élèments d'organisation de type 'Image'"
Write-Host "Saisir un nom pour la création, sinon laisser vide :"
$AssetsLibraryImageURL = Read-Host 'Nom physique'
$AssetsLibraryImage = Read-Host 'Nom'

Write-Host "Création d'une bibliothèque d'élèments d'organisation de type 'Modéle Office'"
Write-Host "Saisir un nom pour la création, sinon laisser vide :"
$AssetsLibraryOffice = Read-Host

if($null -ne $AssetsLibraryImage) {
    Write-Host "Création de la bibliothèque '$AssetsLibraryImage' de type 'Image'"
    Write-Host "dans le site SPO $siteUrlAssetsLibrary"
    Connect-PnPOnline -Url $siteUrlAssetsLibrary -UseWebLogin
    $AssetsLibrary = New-PnPList -Title $AssetsLibraryImage -Url "lists/$AssetsLibraryImageURL" -Template DocumentLibrary
    $LibraryUrl = $siteUrlAssetsLibrary+"/"+$AssetsLibrary.Title
    Add-PnPOrgAssetsLibrary -LibraryUrl "$LibraryUrl" -CdnType Private
}

Add-PnPOrgAssetsLibrary -LibraryUrl "https://m365x33202983.sharepoint.com/Lists/ImagesCorpAssets01" -CdnType Private

Set-PnPTenantCdnEnabled -CdnType Private -Enable $true
