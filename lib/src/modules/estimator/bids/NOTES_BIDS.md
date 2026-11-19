# NOTES_BIDS

Completes the Bids workflow against the Figma "Bids" frames. Nothing here
has been compiled (no Flutter SDK available where this was written) — it
was syntax-checked with a Dart parser and import-checked by script only.
Run `flutter analyze` first; expect small fixes at the seams listed below.

## Screens → files
| Figma frame | File |
|---|---|
| Bids (Bid Board) | `view.dart` → `_BoardSection` |
| "+" dropdown (Frame 6) | `widgets/new_bid_menu.dart` |
| Bids (Bid Inbox) | `view.dart` → `_InboxSection`, `widgets/inbox_bid_card.dart`, `widgets/bid_stat_tile.dart` |
| Bid Details | `views/bid_details_view.dart`, `logic/bid_details_logic.dart` |
| Bids (Calendar) | unchanged — still `CalendarDemoScreen` (see below) |
| Create New Bid (form) | `views/bid_info_step_view.dart` |
| Create New Bid (Upload) | `views/upload_documents_view.dart` |
| AI Document Analysis / Failed | `views/ai_document_analysis_view.dart`, `widgets/ai_analysis_status_card.dart` |
| Confirm Scope of Work | `views/confirm_scope_view.dart` |
| Manual Bid Entry | `views/manual_bid_entry_view.dart` |
| Review Scope Items | `views/review_scope_items_view.dart` |
| Bid Details (final form) | `views/bid_details_review_view.dart` |

## Flows
- **AI-Powered Bid Upload (4 steps):** Details → Upload → AI Scan → Scope → *Create Bid*
  - Upload: "Skip AI Analysis" → Scope (empty). "Analyze Documents" → AI Scan.
  - AI Scan success auto-advances to Scope. Failure: Retry Analysis / Manual Entry (switches to the manual flow) / Skip To Scope.
- **Manual Bid Entry (3 steps):** Info → Scope → Details → *Create Bid*
- `CreateBidWizard.start(CreateBidFlow.ai | .manual)` is the only entry point.
- All wizard routes are named `/create-bid/...`; finishing does one `Get.until` past them, so it works however many screens are stacked. The controller is deleted when the first wizard screen is disposed.
- Create Bid inserts the new bid at the top of the Bid Board as a **Draft** (`EstimatorBidLogic.addBid`).

## Things I had to guess (low-res Figma screenshot — please check)
- Step labels: AI = Details/Upload/AI Scan/Scope; Manual = Info/Scope/Details.
- Bid Inbox: stat tiles (Active/Awarded/Expired) and filter chips (All/Active/Awarded/Expired) are my reading; inbox card layout is approximate.
- Bid Details: "Project Start" row, "Download Documents" button (stubbed) and the Ask Question sheet copy.
- Final form's 5th client field is "Est. Amount" (replaced the old "Bid Method"); it feeds the bid card's AMOUNT.
- Manual Bid Entry's "Add Item(s)" turns the typed scope text into ONE scope item; "Skip" adds none.
- "Use saved contact" / "Link to CRM" prefill from `CreateBidMockData.savedContact()`.

## Seams / follow-ups
- **Calendar tab:** still the field-worker `CalendarDemoScreen`. Figma's Bids calendar has its own legend and Bid Board/Inbox toggle underneath; wire `AppCalendar` with `dayIndicatorsBuilder` + `legends` (due dates) when ready.
- **Bid Date:** uses Flutter `showDatePicker` (`BidDateField` in `widgets/bid_fields.dart`). Swap `_pick` for the `AppCalendar` bottom sheet to match the rest of the app.
- **File picker:** `CreateBidLogic.pickDocument()` is a stub (sets `bid_documents.pdf`).
- **Failure demo:** set `logic.forceAiFailure = true` before "Analyze Documents" to see the failed state.
- **Filter pills** (All Cost Code / Clients / Estimators) on the Board are still visual only.
- `AppEmptyState(showButton: false)` is carried over from the earlier zip — confirm that param exists.
- `AppColors.success` still unconfirmed; the green "ready" banner and CRM chip use literal greens.
- `PillChipWidget(filled: true)` is now used for status chips (uppercase, no icon). The old Bid card passed `filled: false`, which drew the AI icon inside "Awarded".
- Required fields (Bid Name, Client Name, Contact Email, Address) are checked with a snackbar on "Continue to Upload" (AI) / "Create Bid" (manual and AI last step).
- Removed: `views/create_new_bid_view.dart` (now `upload_documents_view.dart`) and `views/manual_scope_item_entry_view.dart` (replaced by `manual_bid_entry_view.dart`). `CreateBidStep` enum is gone; `BidStepIndicator` takes `stepLabels` + `currentIndex`.
- `widgets/bids_list_toggle_row.dart` is untouched and unused on this screen.
