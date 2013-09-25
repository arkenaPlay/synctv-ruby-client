# SynctvRubyClient Changelog

We would like to thank our many {file:Contributors contributors} for
suggestions, ideas and improvements to SynctvRubyClient.

* Table of Contents
{:toc}

## 0.1.6

Removing request parameter from authorize! and client_authorize!

## 0.1.5

Adding new resources:

    Accounts::ContainerLink
    Accounts::Invoice
    Accounts::MediaLink
    Accounts::Ownership
    Accounts::Profile
    AvFormat
    Billing::CreditCard
    Billing::Ewallet
    Billing::Xbox
    Image
    ImageFormat (Platform::ImageFormat)
    IpWhitelist
    Key (DashManifest::Key?)
    Language
    Manifests::Dash
    Manifests::Smooth
    Media::View
    Subtitle
    Ingest::Encodes::Mp4
    Ingest::Manifests::Dash
    Ingest::Manifests::Isp
    Ingest::Manifests::Smooth

## 0.1.4 (2013-08-01)

Fixing a bug where resources are not being required correctly, like Ingest::Video and Ingest::Image.

* adding resources specs

## 0.1.3 (2013-07-31)

Fixed [#2](https://github.com/synctv/synctv-ruby-client/issues/2): Getting media clips throws error.

## 0.1.2 (2013-07-31)

Fixed a problem where unpublished attributes would register a change for dirty attributes.

## 0.1.1 (2013-07-31)

Froze activeresource version to ~> 3.2.13 to avoid decoding problem.

## 0.1.0 (2013-07-30)

Initial release.

