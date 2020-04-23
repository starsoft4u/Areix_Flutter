import 'package:flutter/material.dart';

const primaryColor = Color(0xFF0BF6D5);
const accentColor = Color(0xFFFF7031);
const lightColor = Color(0xFF01897B);
const darkColor = Color(0xFF011D24);

const KEY_SYNC_DATE = "sync_date";
const KEY_SOCIAL_ACCOUNTS = "social_accounts";
const KEY_TRANSACTIONS = "transactions";
const KEY_CASHFLOW = "cashflow";
const KEY_BALANCE = "balance";

const BASE_URL = "https://asia-northeast1-pocketin-fda0c.cloudfunctions.net";

const URL_GET_TRANSACTION =
    "$BASE_URL/transactions/?PSID=2124309861011458&startDate=1554224463000&endDate=1564765263000";
const URL_GET_CASHFLOW = "$BASE_URL/cashflow/?PSID=2124309861011458&startDate=1554224463000&endDate=1564765263000";
const URL_GET_BALANCE = "$BASE_URL/balance/?PSID=2124309861011458";

const ADMOB_APP_ID = "ca-app-pub-2157676184481362~5272332155";
const ADMOB_COUPON_ID = "ca-app-pub-2157676184481362/9463337531";
const ADMOB_PORTAL_ID = "ca-app-pub-2157676184481362/2333493411";
