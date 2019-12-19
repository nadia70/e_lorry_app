import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const fcm = admin.messaging();

export const sendToTopic = functions.firestore
       .document('request/{Item}')
       .onCreate(async snapshot => {

         const message: admin.messaging.MessagingPayload = {
           notification: {
             title: 'New Request!',
             body: `A request has been made`,
           }
         };

         return fcm.sendToTopic('puppies', message);
       });

export const sendToManager = functions.firestore
  .document('requisition/{Item}')
  .onCreate(async snapshot => {

    const message: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Request!',
        body: `New request awaiting approval`,
      }
    };

    return fcm.sendToTopic('manager', message);
  });

